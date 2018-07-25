const Docker = require('dockerode');

const readStream = async (stream) => {
  return new Promise((resolve, reject) => {
    let stdout = '';
    let stderr = '';
    let header = null;

    stream.on('error', reject);

    stream.on('readable', function () {
      header = header || stream.read(8);
      while (header !== null) {
        const type = header.readUInt8(0);
        const payload = stream.read(header.readUInt32BE(4));
        if (payload === null) {
          break;
        }
        if (type === 2) {
          stderr += payload.toString();
        } else {
          stdout += payload.toString();
        }
        header = stream.read(8);
      }
    });

    stream.on('end', () => {
      resolve({ stdout, stderr });
    });
  });
};

class DockerClient {
  constructor(socketPath = '/var/run/docker.sock') {
    this._client = new Docker({ socketPath, version: 'v1.35' });
  }

  filter(filters) {
    this._filter = filters;
  }

  cmd(commands) {
    this._cmd = ['sh', '-c', commands.join(' ')];
    // this._cmd = commands;
  }

  async exec() {
    const docker = this._client;

    const containers = await docker.listContainers({
      filters: JSON.stringify(this._filter)
    });

    const execConfig = {
      Cmd: this._cmd,
      AttachStdout: true,
      AttachStderr: true,
    };

    if (this._user) {
      execConfig.User = this._user;
    }
    if (this._workDir) {
      execConfig.WorkingDir = this._workDir;
    }
    if (this._env) {
      execConfig.Env = this._env;
    }

    const process = containers.map(async data => {
      const container = docker.getContainer(data.Id);
      const exec = await container.exec(execConfig);
      const stream = (await exec.start({
        Detach: false,
      })).output;

      const output = await readStream(stream);

      output.name = data.Names;
      return output;
    });

    return Promise.all(process);
  }

  user(username) {
    this._user = username;
  }

  env(env) {
    this._env = env;
  }

  workDir(path) {
    this._workDir = path;
  }
}

export default DockerClient;