var RequestHandler;
RequestHandler = (function(){
  RequestHandler.displayName = 'RequestHandler';
  var prototype = RequestHandler.prototype, constructor = RequestHandler;
  prototype.get = function(req, res){
    return res.status(405).end();
  };
  prototype.post = function(req, res){
    return res.status(405).end();
  };
  prototype.put = function(req, res){
    return res.status(405).end();
  };
  prototype['delete'] = function(req, res){
    return res.status(405).end();
  };
  function RequestHandler(){}
  return RequestHandler;
}());
module.exports = {
  RequestHandler: RequestHandler
};