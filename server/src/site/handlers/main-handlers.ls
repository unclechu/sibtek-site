require! {
	colors
	\../../core/request-handler : {RequestHandler}
}

class MainHandler extends RequestHandler
	get: (req, res)->
		res.send "NyaaaaaAAAaaa!!!").end!

module.exports = {MainHandler}
