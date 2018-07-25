import dayjs from 'dayjs';
import { inspect } from 'util';
import DockerClient from './dockerClient';
import NextTime from './nextTime';

const beauty = (string, count = 2) => {
  if (typeof string !== 'string') {
    string = inspect(string, { depth: 10 });
  }
  return string.replace(/^(?!\s*$)/mg, ' '.repeat(count))
};

class Task {
  constructor(config) {
    const { options, cmd, time } = config;

    console.log('new task:');
    console.log(beauty(options));
    console.log(beauty(cmd));
    console.log(beauty(JSON.stringify(time)));

    this._name = options.name;
    this._singleton = (['true', true, '1', 1, 'on'].indexOf(options.singleton) >= 0);
    this.prepareClient(options, cmd);

    const { minute, hour, date, month, weekday } = time;
    this._nextTime = new NextTime(minute, hour, date, month, weekday);
  }

  prepareClient(option, cmd) {
    const client = new DockerClient('/tmp/docker.sock');

    const { dir, env, user, filter } = option;

    client.workDir(dir);
    client.env(env);
    client.user(user);
    client.filter(filter);
    client.cmd(cmd);

    this._client = client;
  }

  async run() {
    const start = new Date();
    console.log(`==== [START] ${this._name} ====
  start: ${dayjs(start).format('YYYY/MM/DD HH:mm:ss:S')}
`);
    const result = await this._client.exec();
    const end = new Date();

    const log = result.map(output => {
      const log = [];

      log.push(`name: ${output.name}`);
      if (output.stdout.length) {
        log.push(`stdout:\n${beauty(output.stdout)}`)
      }
      if (output.stderr.length) {
        log.push(`stderr:\n${beauty(output.stderr)}`)
      }

      return log.join('\n');
    }).join('\n');

    console.log(`==== [END] ${this._name} ====
  start: ${dayjs(start).format('YYYY/MM/DD HH:mm:ss:S')}
  end: ${dayjs(end).format('YYYY/MM/DD HH:mm:ss:S')}
${log}`);
  }

  start() {
    const next = this._nextTime.get();
    const timeout = next.valueOf() - Date.now();

    console.log(`==== [TASK] ${this._name} ====
  now: ${dayjs().format('YYYY/MM/DD HH:mm:ss:S')}
  delay: ${timeout} ms
`);

    const self = this;
    if (this._singleton) {
      setTimeout(async () => {
        await self.run();
        self.start();
      }, timeout);
    } else {
      setTimeout(async () => {
        // no await
        self.run();
        self.start();
      }, timeout);
    }
  }
}

export default Task;
