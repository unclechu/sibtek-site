require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {ContentPage, DiffData, MailData}
	\../../adm/models/models : {User}
	\../utils : {go-auth, block-post, has-crap}
	\../../site/traits : {page-trait}
}


class ListAdmHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		type = req.params.type
		if type is \main-page
			return res.redirect "/admin/main-page/edit/0"
		
		data = ContentPage.find type: type
		
		list-page-data = ContentPage
			.find-one type: \list-page
			.where \metadata.type
			.equals type
		
		(err, list-data) <-! list-page-data.exec
		return if has-crap res, err
		
		(err, pages) <-!  data.exec
		return if has-crap res, err
		
		(err, html) <-! res.render 'list', {menu, pages, type, page-trait, list-data}
		return if has-crap res, err
		
		res.send html .end!
		
	post: (req, res)!->
		return if block-post req, res
		
		data = JSON.parse req.body.data
		
		page = ContentPage
			.where \type
			.equals data.type
			.where \metadata.type
			.equals data.metadata.type
			.set-options overwrite: true
		
		(err, status) <-! page.update data
		return if has-crap res, err
		
		res.json status: unless status then \error else \success


class DataListAdmHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		type = req.params.type
		
		data = DiffData.find type: type
		
		list-page-data = ContentPage
			.find-one type: \list-page
			.where \metadata.type
			.equals type
		
		(err, list-data) <-! list-page-data.exec
		return if has-crap res, err
		
		(err, data) <-! data.exec
		return if has-crap res, err
		
		(err, html) <-! res.render 'data-list', {menu, data, type, page-trait, list-data}
		return if has-crap res, err
		
		res.send html .end!


class UsersListAdmHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		users = User.find!
		
		(err, users) <-! users.exec
		return if has-crap res, err
		
		(err, html) <-! res.render 'users-list', {
			menu
			users
			type: \users
			page-trait
		}
		return if has-crap res, err
		
		res.send html .end!


class DeleteListElementHandler extends RequestHandler
	post: (req, res)!->
		return if block-post req, res
		
		type = req.params.type
		element = {}
		
		switch type
		| <[articles services news clients]> =>
			element := ContentPage.find-by-id req.body.id
		| <[calls messages]> =>
			element := MailData.find-by-id req.body.id
		| <[contacts others]> =>
			element := DiffData.find-by-id req.body.id
		| \users =>
			element := User.find-by-id req.body.id
		| otherwise =>
			err = new Error 'Unknown model'
			return if has-crap res, err
		
		element.remove!
		
		(err, status) <-! element.exec
		return if has-crap res, err
		
		res.json status: \success


class MailListHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		type = req.params.type
		
		mail-data = MailData.find type: type
		
		(err, emails) <-! mail-data.exec
		return if has-crap res, err
		
		(err, html) <-! res.render 'emails-list', {menu, emails, type, page-trait}
		return if has-crap res, err
		
		res.send html .end!


module.exports = {
	ListAdmHandler
	DataListAdmHandler
	UsersListAdmHandler
	MailListHandler
	DeleteListElementHandler
}
