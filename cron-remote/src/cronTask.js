import parser from './cron/parser';
import Task from './cron/task';

const start = async () => {
  console.log('>>>\n   cron start\n>>>');
  const tasks = await parser.parse(`${__dirname}/../cron/**/*.cron`);

  console.log('total task number:', tasks.length);

  tasks.forEach(config => {
    const task = new Task(config);
    task.start();
    // task.run();
  });
};

export default {
  start,
}
