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

		data = Content-page.find {type: type}
		data.exec (err, pages)!~>
			if err then res.send-status 500 and console.error error
			res.render 'list', {menu, pages, type, page-trait}, (err, html)->
				if err then res.send-status 500  .end!  and console.log error
				res.send html  .end!


class DataListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		type = req.params.type
		console.log type
		data = DiffData
			.find type: type
			.exec (err, data)!->
				if err then res.send-status 500 and console.error error
				console.log data.length
				res.render 'data-list', {menu, data, type, page-trait}, (err, html)->
					if err then res.send-status 500  .end! and console.error err
					res.send html  .end!


class UsersListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		users = User.find!
		users.exec (err, users)!->
			if err then res.send-status 500 and console.error error
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
