require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../models/models : {ContentPage}
	\../traits : {page-trait, static-url}
	\../utils : {menu-handler, rel-url}
	path
	util
}


class MainHandler extends RequestHandler
	get: (req, res)!->
		page = ContentPage.find-one {type: \main-page}
		page.exec (err, data)!->
			if err then res.status 404  .end! and console.error err
			data = data.toJSON! <<<< page-trait <<<< {is-main-page: true} <<<< {static-url}

			(err, new-menus) <-! menu-handler req, page-trait.menu
			if err?
				res.status 500 .end '500 Internal Server Error'
				return console.error err
			data.menu = new-menus

			(err, html) <-! res.render 'site/pages/main.jade', data
			if err?
				res.status 500 .end '500 Internal Server Error'
				return console.error err

			# console.log util.inspect data, depth: 10
			res.send html .end!



class PageHandler extends RequestHandler
	get: (req, res)!->


class ListPageHandler extends RequestHandler
	get: (req, res)!->
		console.log req.params.item


class DevHandler extends RequestHandler
	get: (req, res)!->
		res.render 'site/' + req.params.template, (err, html)!->
			if err then res.status 500 .end! and console.error err
			res.send html  .end!


module.exports = {MainHandler, PageHandler, DevHandler}
