require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../models/models : {ContentPage}
	\../utils : {menu-handler, rel-url, get-all-template-data, classic-error-handler}
	path
	util
}

class MainHandler extends RequestHandler
	get: (req, res)!->
		page = ContentPage
			.find-one type: \main-page
			.exec (err, page-data)!->
				return classic-error-handler err, res, 404 if err or not page-data?

				(err, data) <-! get-all-template-data req
				return classic-error-handler err, res, 500 if err or not data?

				data <<<< {is-main-page: true} <<<< page-data.toJSON!

				(err, html) <-! res.render 'site/pages/index.jade', data
				return classic-error-handler err, res, 500 if err or not html?

				res.send html .end!


class PageHandler extends RequestHandler
	get: (req, res)!->
		page = ContentPage
			.find-one do
				urlpath: req.params.page.to-string! .replace \.html, ''
				type: (req.path.split \/).1
			.exec (err, page-data)!->
				return classic-error-handler err, res, 404 if err? or not page-data?
				get-all-menus req, res, page-data, (result)!->
					res.json result


class ListPageHandler extends RequestHandler
	get: (req, res)!->
		console.log req.params.item

module.exports = {MainHandler, PageHandler}
