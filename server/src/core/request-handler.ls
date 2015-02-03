
class RequestHandler
	get: (req, res)->
		res.status 405 .end!
	post: (req, res)->
		res.status 405 .end!
	put: (req, res)->
		res.status 405 .end!
	delete: (req, res)->
		res.status 405 .end!


module.exports = {RequestHandler}
