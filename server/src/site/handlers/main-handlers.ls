require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../models/models : {ContentPage, DiffData, ServicesList}
	\../utils : {
		menu-handler
		rel-url
		get-all-template-data
		classic-error-handler
	}
	path
}


class MainHandler extends RequestHandler
	get: (req, res)!->
		page = ContentPage.find-one type: \main-page
		
		(err, page-data) <-! page.exec
		return classic-error-handler err, res, 404 if err? or not page-data?
		
		(err, data) <-! get-all-template-data req
		return classic-error-handler err, res, 500 if err? or not data?
		
		data <<<< {is-main-page: true} <<<< page-data.toJSON!
		
		services-list = ServicesList.find!
		
		(err, services-list) <-! services-list.exec
		return classic-error-handler err, res, 500 if err?
		
		data <<<< {
			services-list: [{
				id: x._id.to-string!
				name: x.name
				link: x.link
			} for x in services-list]
		}
		
		(err, html) <-! res.render 'index.jade', data
		return classic-error-handler err, res, 500 if err? or not html?
		res.send html .end!


class PageHandler extends RequestHandler
	get: (req, res)!->
		type = (req.path.split \/).1
		page = ContentPage
			.find-one do
				symbol-code: req.params.page.to-string!.replace \.html, ''
				type: type
		
		(err, page-data) <-! page.exec
		return classic-error-handler err, res, 404 if err? or not page-data?
		
		(err, data) <-! get-all-template-data req
		return classic-error-handler err, res, 500 if err? or not data?
		
		data <<<< {is-main-page: false} <<<< page-data.toJSON!
		
		(err, html) <-! res.render "page.jade", data
		return classic-error-handler err, res, 500 if err? or not html?
		res.send html .end!


class ListPageHandler extends RequestHandler
	get: (req, res)!->
		type = req.path.to-string! - \/ - \/
		page = ContentPage
			.find type: type
			.sort pub-date: \desc
			.limit 10
		
		list-page-data = ContentPage
			.find-one type : \list-page
			.where('metadata.type')
			.equals(type)
		
		(err, data-list) <-! page.exec
		return classic-error-handler err, res, 404 if err?
		
		(err, list-data) <-! list-page-data.exec
		if err then res.send-status 500 and console.error error
		
		(err, data) <-! get-all-template-data req
		return classic-error-handler err, res, 500 if err? or not data?
		page-object =
			seo: list-data.seo or {}
			header: list-data.header
			type: type
		
		data <<<< {is-main-page: false} <<<< {
			elements-list: [x.toJSON! for x in data-list]
		} <<<< page-object
		(err, html) <-! res.render "list.jade", data
		return classic-error-handler err, res, 500 if err? or not html?
		res.send html .end!


class ContactsPageHandler extends RequestHandler
	get: (req, res)!->
		type = \contacts
		
		list-page-data = ContentPage
			.find-one type : \list-page
			.where('metadata.type')
			.equals(type)
		
		(err, list-data) <-! list-page-data.exec
		if err then res.send-status 500 and console.error error
		
		(err, data) <-! get-all-template-data req
		return classic-error-handler err, res, 500 if err? or not data?
		page-object =
			seo: list-data.seo or {}
			header: list-data.header
			type: type
		
		data <<<< {is-main-page: false} <<<< page-object
		
		(err, html) <-! res.render "page.jade", data
		return classic-error-handler err, res, 500 if err? or not html?
		res.send html .end!
		
	post: (req, res)!->
		data = DiffData.find type: \contacts
		
		(err, contacts) <-! data.exec
		return classic-error-handler err, res, 500 if err?
		
		res.json [x.toJSON! for x in contacts]


module.exports = {MainHandler, PageHandler, ListPageHandler, ContactsPageHandler}
