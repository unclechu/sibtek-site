require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../utils : {go-auth}
}


class MainAdmHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		res.redirect \/admin/main-page/edit/0


module.exports = {MainAdmHandler}
