require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../utils : {is-auth}
}


class MainAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		res.redirect \/admin/main-page/edit/0


module.exports = {MainAdmHandler}
