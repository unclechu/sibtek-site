require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
}


class MainAdmHandler extends RequestHandler
	get: (req, res)!->
		res.render 'admin/adm-layout', {menu}, (err, html)->
			if err then res.send-status 500  .end!  and console.error error
			res.send html  .end!


module.exports = {MainAdmHandler}
