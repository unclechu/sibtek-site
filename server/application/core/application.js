var colors, express, http, urls, config, app, site, methods, i$, len$, item, method, ref$, fn, port;
colors = require('colors');
express = require('express');
http = require('http');
urls = require('../site/urls');
config = require('../config-parser');
app = express();
site = express();
app.engine('jade', require('jade').__express);
app.use('/', site);
methods = ['get', 'post', 'put', 'delete'];
for (i$ = 0, len$ = urls.length; i$ < len$; ++i$) {
  item = urls[i$];
  for (method in ref$ = new item.handler().__proto__) {
    fn = ref$[method];
    if (in$(method, methods)) {
      site[method](item.url, fn);
    }
  }
}
port = config.DEV.PORT;
http.createServer(site).listen(port);
console.log(("Server start in port " + port.toString().yellow).green);
function in$(x, xs){
  var i = -1, l = xs.length >>> 0;
  while (++i < l) if (x === xs[i]) return true;
  return false;
}