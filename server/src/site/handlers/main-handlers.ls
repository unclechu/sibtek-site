require! {
	colors
	\../../core/request-handler : {RequestHandler}
}

class MainHandler extends RequestHandler
	get: (req, res)!->
		res.send "Nyaaa!!! lol" .end!


class DevHandler extends RequestHandler
	get: (req, res)!->
		res.render req.params.template

module.exports = {MainHandler, DevHandler}
