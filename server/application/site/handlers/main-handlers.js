var colors, RequestHandler, MainHandler, DevHandler;
colors = require('colors');
RequestHandler = require('../../core/request-handler').RequestHandler;
MainHandler = (function(superclass){
  var prototype = extend$((import$(MainHandler, superclass).displayName = 'MainHandler', MainHandler), superclass).prototype, constructor = MainHandler;
  prototype.get = function(req, res){
    res.send("Nyaaa!!! lol").end();
  };
  function MainHandler(){
    MainHandler.superclass.apply(this, arguments);
  }
  return MainHandler;
}(RequestHandler));
DevHandler = (function(superclass){
  var prototype = extend$((import$(DevHandler, superclass).displayName = 'DevHandler', DevHandler), superclass).prototype, constructor = DevHandler;
  prototype.get = function(req, res){
    res.render(req.params.template);
  };
  function DevHandler(){
    DevHandler.superclass.apply(this, arguments);
  }
  return DevHandler;
}(RequestHandler));
module.exports = {
  MainHandler: MainHandler,
  DevHandler: DevHandler
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