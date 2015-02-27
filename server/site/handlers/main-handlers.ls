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
		type = (req.path.split \/).1
		ContentPage
			.find-one do
				symbol-code: req.params.page.to-string! .replace \.html, ''
				type: type

			.exec (err, page-data)!->
				return classic-error-handler err, res, 404 if err? or not page-data?

				(err, data) <-! get-all-template-data req
				return classic-error-handler err, res, 500 if err or not data?

				data <<<< {is-main-page: false} <<<< page-data.toJSON!

				(err, html) <-! res.render "page.jade", data
				return classic-error-handler err, res, 500 if err or not html?
				res.send html .end!


class ListPageHandler extends RequestHandler
	get: (req, res)!->
		type = req.path.to-string! - \/ - \/
		ContentPage
			.find type: type
			.sort pub-date: \desc
			.limit 10
			.exec (err, data-list) !->
				return classic-error-handler err, res, 404 if err?

				(err, data) <-! get-all-template-data req
				return classic-error-handler err, res, 500 if err or not data?
				page-object =
					seo:
						title: type
						description: ''
						keywords: ''
					header: type
					type: type

				data <<<< {is-main-page: false} <<<< { elements-list: [x.toJSON! for x in data-list] } <<<< page-object
				(err, html) <-! res.render "list.jade", data
				return classic-error-handler err, res, 500 if err or not html?
				res.send html .end!

	post: (req, res)!->



class ContactsPageHandler extends RequestHandler
	get: (req, res)!->
		type = \contacts
		(err, data) <-! get-all-template-data req
		return classic-error-handler err, res, 500 if err or not data?
		page-object =
			seo:
				title: type
				description: ''
				keywords: ''
			header: type
			type: type

		data <<<< {is-main-page: false} <<<< page-object

		(err, html) <-! res.render "page.jade", data
		return classic-error-handler err, res, 500 if err or not html?
		res.send html .end!


module.exports = {MainHandler, PageHandler, ListPageHandler, ContactsPageHandler}
