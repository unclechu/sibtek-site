var colors, express, http, urls, config, app, site, methods, createUrls, port;
colors = require('colors');
express = require('express');
http = require('http');
urls = require('../site/urls');
config = require('../config-parser');
app = express();
site = express();
app.engine('jade', require('jade').__express);
app.use('/', site);
app.use(express['static'](__dirname + config.STATIC_PATH));
app.set('views', process.cwd() + '/' + config.TEMPLATES_PATH);
console.log("Templates path: ", app.get('views'));
methods = ['get', 'post', 'put', 'delete'];
createUrls = function(obj){
  var i$, ref$, len$, item, lresult$, method, ref1$, fn, results$ = [];
  for (i$ = 0, len$ = (ref$ = urls).length; i$ < len$; ++i$) {
    item = ref$[i$];
    lresult$ = [];
    for (method in ref1$ = new item.handler().__proto__) {
      fn = ref1$[method];
      if (in$(method, methods)) {
        lresult$.push(obj[method](item.url, fn));
      }
    }
    results$.push(lresult$);
  }
  return results$;
};
createUrls(site);
port = config.DEV.PORT;
http.createServer(site).listen(port);
console.log(("Server start in port " + port.toString().yellow).green);
function in$(x, xs){
  var i = -1, l = xs.length >>> 0;
  while (++i < l) if (x === xs[i]) return true;
  return false;
}