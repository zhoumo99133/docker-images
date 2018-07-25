import fs from 'fs';
import glob from 'glob';
import { promisify } from 'util';
import parser from '../grammar/crontab-grammar';

const aglob = promisify(glob);

const parse = async (glob) => {
  let tasks = [];
  let files;
  try {
    files = await aglob(glob, { nodir: true });
  } catch (e) {
    console.log(e);
  }

  files.forEach((file) => {
    try {
      console.log('> parse crontab file:', file);
      const subTasks = parser.parse(fs.readFileSync(file, 'utf8'));
      console.log('sub task number:', subTasks.length);
      tasks = tasks.concat(subTasks);
    } catch (e) {
      console.error(e);
    }
  });

  return tasks;
};

export default {
  parse,
};