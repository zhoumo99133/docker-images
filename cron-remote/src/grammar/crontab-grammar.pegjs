{
  const makeInteger = (int) => parseInt(int.join(''), 10);

  const intInRange = (int, min, max) => {
  	if (min <= int && int <= max) { return int; }
    expected(`number in [${min},${max}]`);
  };

  const range = (left, right, min=0, max=59) => {
    if (left > right) {
      return range(min, right).concat(range(left, max));
    }
    const arr = [];
    for (let i = left; i<=right; i++) { arr.push(i); }
    return arr;
  };

  const getStep = (list, step) => {
    const arr = [];
    for (let i = 0; i<list.length; i+=step) { arr.push(list[i]); }
    return arr;
  };

  const sortUnique = (arr) => {
    return arr
      .filter((value, index, self) => {
        return self.indexOf(value) === index;
      })
      .sort((a, b) => { return a-b; });
  };
}

start
  = left:cron nl+ right:start
    { return right.concat(left); }
  / item:cron nl*
    { return [item]; }

cron
  = options:options nl+ time:timeField ws+ cmd:command
    { return { options, cmd, time}; }
  / time:timeField ws+ cmd:command
    { return { options: {}, cmd, time}; }

// === option ===
options
  = options:optionBlock
    {
      const obj = {};
      options.forEach(option => {
        const { key, value, type } = option;
        switch (type) {
          case 'overwrite':
            obj[key] = value;
            break;
          case 'array':
            if (!obj.hasOwnProperty(key)) {
              obj[key] = [];
            }
            obj[key].push(value);
            break;
          case 'object':
            const { field } = option;
            if (!obj.hasOwnProperty(key)) {
              obj[key] = {};
            }
            if (!obj[key].hasOwnProperty(field)) {
              obj[key][field] = [];
            }
            obj[key][field].push(value);
            break;
        }
      })
      return obj;
    }

optionBlock
  = left:optionItem nl+ right:optionBlock
    { return right.concat(left); }
  / item:optionItem
    { return [item]; }

optionItem
  = optionKV
  / optionArr
  / optionObject
  / comment

comment
  = "//" (!nl .)* { return {key: null, value: null, type: 'comment'}; }

optionObject
  = "//" ws* key:optionObjKeyword ":" ws* field:optionObjField ":" ws* value:optionValue+
  { return { key, field, value:value.join(''), type: 'object'}; }

optionObjField
  = "ancestor"
  / "before"
  / "expose"
  / "exited"
  / "health"
  / "id"
  / "isolation"
  / "label"
  / "name"
  / "network"
  / "publish"
  / "since"
  / "status"
  / "volume"

optionObjKeyword
  = "filter"

optionArr
  = "//" ws* key:optionArrKeyword ":" ws* value:optionValue+
  { return { key, value:value.join(''), type: 'array'}; }

optionArrKeyword
  = "env"

optionKV
  = "//" ws* key:optionKVKeyword ":" ws* value:optionValue+
  { return { key, value:value.join(''), type: 'overwrite'}; }

optionValue
  = !nl char:. { return char; }

optionKVKeyword
  = "name"
  / "user"
  / "dir"
  / "singleton"

// === command ===
command
  = left:cmdChunk ws+ right:command
    { return left.concat(right); }
  / cmdChunk

cmdChunk
  = chunk:quote1 { return [chunk]; }
  / chunk:quote2 { return [chunk]; }
  / chunk:quote3 { return [chunk]; }
  / chunk:noQuote { return [chunk]; }

noQuote = chars:noQuoteChar+ { return chars.join(''); }
noQuoteChar = !["'`] !ws !nl char:. { return char; }

quote1
  = ["] chars:quote1Char+ ["]
    { return chars.join(''); }

quote1Char
  = "\\" char:["] { return char; }
  / !["] !nl char:. { return char; }

quote2
  = ['] chars:quote2Char+ [']
    { return chars.join(''); }

quote2Char
  = "\\" char:['] { return char; }
  / !['] !nl char:. { return char; }

quote3
  = [`] chars:quote3Char+ [`]
    { return chars.join(''); }

quote3Char
  = "\\" char:[`] { return char; }
  / ![`] !nl char:. { return char; }


// === time ===
timeField
  = minute:minuteField ws+
    hour:hourField ws+
    date:dateField ws+
    month:monthField ws+
    weekday:weekdayField
    {
      return {
        minute: sortUnique(minute),
        hour: sortUnique(hour),
        date: sortUnique(date),
        month: sortUnique(month),
        weekday: sortUnique(weekday),
      };
    }

// minute
minuteField
  = left:minuteValue "," right:minuteField
    { return left.concat(right); }
  / minuteValue

minuteValue
  = minuteStep
  / minuteRange
  / minuteSingle

minuteStep
  = list:minuteRange "/" step:[1-9]
    { return getStep(list, +step); }

minuteRange
  = left:minuteDigit "-" right:minuteDigit
    { return range(left, right, 0, 59); }
  / "*"
    { return range(0, 59); }

minuteSingle
  = val:minuteDigit { return [val]; }

minuteDigit
  = digits:[0-9]+
    { return intInRange(makeInteger(digits), 0, 59); }

// hour
hourField
  = left:hourValue "," right:hourField
    { return left.concat(right); }
  / hourValue

hourValue
  = hourStep
  / hourRange
  / hourSingle

hourStep
  = list:hourRange "/" step:[1-9]
    { return getStep(list, +step); }

hourRange
  = left:hourDigit "-" right:hourDigit
    { return range(left, right, 0, 23); }
  / "*"
    { return range(0, 23); }

hourSingle
  = val:hourDigit { return [val]; }

hourDigit
  = digits:[0-9]+
    { return intInRange(makeInteger(digits), 0, 23); }

// date
dateField
  = left:dateValue "," right:dateField
    { return left.concat(right); }
  / dateValue

dateValue
  = dateStep
  / dateRange
  / dateSingle

dateStep
  = list:dateRange "/" step:[1-9]
    { return getStep(list, +step); }

dateRange
  = left:dateDigit "-" right:dateDigit
    { return range(left, right, 0, 31); }
  / "*"
    { return range(0, 31); }

dateSingle
  = val:dateDigit { return [val]; }

dateDigit
  = digits:[0-9]+
    { return intInRange(makeInteger(digits), 0, 31); }

// month
monthField
  = left:monthValue "," right:monthField
    { return left.concat(right); }
  / monthValue

monthValue
  = monthStep
  / monthRange
  / monthSingle

monthStep
  = list:monthRange "/" step:[1-9]
    { return getStep(list, +step); }

monthRange
  = left:monthDigit "-" right:monthDigit
    { return range(left, right, 0, 12); }
  / "*"
    { return range(0, 12); }

monthSingle
  = val:monthDigit { return [val]; }

monthDigit
  = digits:[0-9]+
    { return intInRange(makeInteger(digits), 0, 12); }

// weekday
weekdayField
  = left:weekdayValue "," right:weekdayField
    { return left.concat(right); }
  / weekdayValue

weekdayValue
  = weekdayStep
  / weekdayRange
  / weekdaySingle

weekdayStep
  = list:weekdayRange "/" step:[1-9]
    { return getStep(list, +step); }

weekdayRange
  = left:weekdayDigit "-" right:weekdayDigit
    { return range(left, right, 0, 7); }
  / "*"
    { return range(0, 7); }

weekdaySingle
  = val:weekdayDigit { return [val]; }

weekdayDigit
  = digits:[0-9]+
    { return intInRange(makeInteger(digits), 0, 7); }

// others
ws "whitespace" = [ \t]

nl "newline" = [\n\r]
