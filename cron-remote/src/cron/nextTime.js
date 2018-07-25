import dayjs from 'dayjs';

/*
cron
field          allowed values
-----          --------------
minute         0-59
hour           0-23
day of month   0-31
month          0-12
day of week    0-7 (0 or 7 is Sun)
 */
/*
js
field          values
-----          --------------
minute         0-59
hour           0-23
day of month   1-31
month          0-11
day of week    0-6
 */

const fixDate = (date) => {
  if (date[0] === 0) {
    date.shift();
    if (date[0] !== 1) {
      date.unshift(1);
    }
  }

  return date;
};

const fixMonth = (month) => {
  if (month[month.length - 1] === 12) {
    month.pop();
    if (month[0] !== 0) {
      month.unshift(0);
    }
  }

  return month;
};

const fixWeekday = (weekday) => {
  if (weekday[weekday.length - 1] === 7) {
    weekday.pop();
    if (weekday[0] !== 0) {
      weekday.unshift(0);
    }
  }

  return weekday;
};

class NextTime {
  constructor(minute, hour, date, month, weekday) {
    date = fixDate(date);
    month = fixMonth(month);
    weekday = fixWeekday(weekday);

    this.isValid = (time) => {
      return minute.indexOf(time.minute()) >= 0
        && hour.indexOf(time.hour()) >= 0
        && date.indexOf(time.date()) >= 0
        && month.indexOf(time.month()) >= 0
        && weekday.indexOf(time.day()) >= 0;
    };
  }

  get() {
    let time = dayjs().startOf('minute');
    let i = 0;
    const maxLoop = 525600; // 365 * 24 * 60

    do {
      i++;
      time = time.add(1, 'minutes');
    } while (i < maxLoop && !this.isValid(time));

    if (i >= maxLoop) {
      throw new Error('Can not find a correct time in 365 days!');
    }

    return time;
  }
}

export default NextTime;