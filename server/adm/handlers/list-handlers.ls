require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../../core/email : send-mail
	\../ui-objects/menu : menu
	\../../site/models/models : {ContentPage, DiffData, MailData}
	\../../adm/models/models : {User}
	\../utils : {is-auth}
	\../../config-parser : config
	\../../site/traits : {page-trait}
}


class ListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login

		type = req.params.type
		if type is \main-page
			return res.redirect "/admin/main-page/edit/0"

		data = ContentPage.find {type: type}

		list-page-data = ContentPage
			.find-one type : \list-page
			.where('metadata.type')
			.equals(type)

		(err, list-data) <-! list-page-data.exec
		return res.send-status 500 and console.error error if err?

		(err, pages) <-!  data.exec
		return res.send-status 500 and console.error error if err?

		(err, html) <-! res.render 'list', {menu, pages, type, page-trait, list-data}
		return res.send-status 500 and console.error error if err?
		res.send html  .end!


	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		data = JSON.parse req.body.data
		Content-page
			.where \type
			.equals data.type
			.where \metadata.type
			.equals(data.metadata.type)
			.setOptions { overwrite: true }
			.update (data), (err, status)!->
				return res.send-status 500 and console.error error if err?
				unless status
					res.json {status: \error}
				else
					res.json {status: \success}



class DataListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		type = req.params.type

		data = DiffData
			.find type: type

		list-page-data = ContentPage
			.find-one type : \list-page
			.where('metadata.type')
			.equals(type)

		(err, list-data) <-! list-page-data.exec
		return res.send-status 500 and console.error error if err?

		(err, data) <-! data.exec
		return res.send-status 500 and console.error error if err?
		console.log data
		(err, html) <-! res.render 'data-list', {menu, data, type, page-trait, list-data}
		return res.send-status 500 and console.error error if err?
		res.send html  .end!



class UsersListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		users = User.find!
		users.exec (err, users)!->
			return res.send-status 500 and console.error error if err?
			res.render 'users-list', {menu, users, type:\users, page-trait}, (err, html)->
				if err then res.send-status 500  .end! and console.error err
				res.send html  .end!


class DeletelistElementHandler extends RequestHandler
	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		type = req.params.type
		element = {}
		switch type
		| <[articles services news clients]> =>
			element := ContentPage.find {_id: req.body.id}
		| <[calls messages]> =>
			element := MailData.find {_id: req.body.id}
		| <[contacts others]> =>
			element := DiffData.find {_id: req.body.id}
		| \users =>
			element := User.find {_id: req.body.id}
		| otherwise return res.status 500  .json status: \error if err?
		element.remove!
		element.exec (err, status)!->
			return res.status 500  .json status: \error if err?
			res.json status: \success



class MailListHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		type = req.params.type
		MailData
			.find type: type
			.exec (err, emails)!->
				res.render 'emails-list', {menu, emails, type, page-trait}, (err, html)->
					if err then res.send-status 500  .end! and console.error err
					res.send html  .end!



module.exports = {ListAdmHandler, DataListAdmHandler, UsersListAdmHandler, MailListHandler, DeletelistElementHandler}
