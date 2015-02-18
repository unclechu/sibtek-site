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
		ContentPage
			.find-one type: \main-page
			.exec (err, page-data)!->
				return classic-error-handler err, res, 404 if err or not page-data?

				(err, data) <-! get-all-template-data req
				return classic-error-handler err, res, 500 if err or not data?

				data <<<< {is-main-page: true} <<<< page-data.toJSON!

				(err, html) <-! res.render 'index.jade', data
				return classic-error-handler err, res, 500 if err or not html?
				res.send html .end!



class PageHandler extends RequestHandler
	get: (req, res)!->
		ContentPage
			.find-one do
				symbol-code: req.params.page.to-string! .replace \.html, ''
				type: (req.path.split \/).1

			.exec (err, page-data)!->
				return classic-error-handler err, res, 404 if err? or not page-data?

				(err, data) <-! get-all-template-data req
				return classic-error-handler err, res, 500 if err or not data?

				data <<<< {is-main-page: true} <<<< page-data.toJSON!

				(err, html) <-! res.render "#{type}-detail.jade", data
				return classic-error-handler err, res, 500 if err or not html?
				res.send html .end!



class ListPageHandler extends RequestHandler
	get: (req, res)!->
		type = req.path.to-string! - \/ - \/
		ContentPage
			.find type: type
			.exec (err, data-list) !->
				return classic-error-handler err, res, 404 if err?

				(err, data) <-! get-all-template-data req
				return classic-error-handler err, res, 500 if err or not data?

				data <<<< {is-main-page: true} <<<< { elements-list: [x.toJSON! for x in data-list] }

				# res.json data .end!
				(err, html) <-! res.render "#{type}-list.jade", data
				return classic-error-handler err, res, 500 if err or not html?
				res.send html .end!

module.exports = {MainHandler, PageHandler, ListPageHandler}
