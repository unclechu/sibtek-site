var colors, RequestHandler, MainHandler;
colors = require('colors');
RequestHandler = require('../../core/request-handler').RequestHandler;
MainHandler = (function(superclass){
  var prototype = extend$((import$(MainHandler, superclass).displayName = 'MainHandler', MainHandler), superclass).prototype, constructor = MainHandler;
  prototype.get = function(req, res){
    return res.send("NyaaaaaAAAaaa!!!").end();
  };
  function MainHandler(){
    MainHandler.superclass.apply(this, arguments);
  }
  return MainHandler;
}(RequestHandler));
module.exports = {
  MainHandler: MainHandler
};
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}