require! {
	colors
	\../../core/request-handler : {RequestHandler}
}

class MainHandler extends RequestHandler
	get: (req, res)!->
		res.send "Nyaaa!!! lol" .end!


class DevHandler extends RequestHandler
	get: (req, res)!->
		res.render 'loollo.jade'

module.exports = {MainHandler, DevHandler}
