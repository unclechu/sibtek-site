require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../utils : {is-auth}
}


class MainAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		res.render 'main-admin', {menu}, (err, html)->

			if err then res.send-status 500  .end!  and console.error error
			res.send html  .end!


module.exports = {MainAdmHandler}
