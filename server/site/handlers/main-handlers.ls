require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../models/models : {ContentPage}
	\../utils : {menu-handler, rel-url, get-all-menus, classic-error-handler}
	path
	util
}

class MainHandler extends RequestHandler
	get: (req, res)!->
		page = ContentPage
			.find-one type: \main-page
			.exec (err, data)!->
				return classic-error-handler err, res, 404 if err or not data
				get-all-menus req, res, data, (result)!->
					(err, html) <-! res.render 'site/pages/index.jade', result
					if err? then return classic-error-handler err, res, 500
					res.send html .end!


class PageHandler extends RequestHandler
	get: (req, res)!->
		page = ContentPage
			.find-one {
				urlpath: req.params.page.to-string! .replace \.html, ''
				type: (req.path.split \/).1 }
			.exec (err, page-data)!->
				return classic-error-handler err, res, 404 if err? or not page-data
				get-all-menus req, res, page-data, (result)!->
					res.json result


class ListPageHandler extends RequestHandler
	get: (req, res)!->
		console.log req.params.item

module.exports = {MainHandler, PageHandler}
