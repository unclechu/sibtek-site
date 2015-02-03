var colors, MainHandler;
colors = require('colors');
MainHandler = require('./handlers/main-handlers').MainHandler;
module.exports = [
  {
    url: '/',
    handler: MainHandler
  }, {
    url: '/lol',
    handler: MainHandler
  }
];