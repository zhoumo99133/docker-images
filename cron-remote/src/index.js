import cron from './cronTask';

process.on('unhandledRejection', (error, p) => {
  console.log('Unhandled Rejection at: Promise', p)
  console.log('reason:', error);
});

cron.start();