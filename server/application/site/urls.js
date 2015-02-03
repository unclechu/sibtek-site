var colors, ref$, MainHandler, DevHandler;
colors = require('colors');
ref$ = require('./handlers/main-handlers'), MainHandler = ref$.MainHandler, DevHandler = ref$.DevHandler;
module.exports = [
  {
    url: '/',
    handler: MainHandler
  }, {
    url: '/lol',
    handler: MainHandler
  }, {
    url: '/test/:template',
    handler: DevHandler
  }
];