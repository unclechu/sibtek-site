require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../../core/email : send-mail
	\../ui-objects/menu : menu
	\../../site/models/models : {ContentPage, DiffData, MailData}
	\../../adm/models/models : {User}
	\../utils : {is-auth}
}


class ListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login

		type = req.params.type
		if type is \main-page
			return res.redirect \/admin

		data = Content-page.find {type: type}
		data.exec (err, pages)!~>
			if err then res.send-status 500 and console.error error
			res.render 'list', {menu, pages, type}, (err, html)->
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
				res.render 'data-list', {menu, data, type}, (err, html)->
					if err then res.send-status 500  .end! and console.error err
					res.send html  .end!


class UsersListAdmHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		users = User.find!
		users.exec (err, users)!->
			if err then res.send-status 500 and console.error error
			res.render 'users-list', {menu, users}, (err, html)->
				if err then res.send-status 500  .end! and console.error err
				res.send html  .end!


class MailListHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		type = req.params.type
		MailData
			.find type: type
			.exec (err, emails)!->
				res.render 'emails-list', {menu, emails}, (err, html)->
					if err then res.send-status 500  .end! and console.error err
					res.send html  .end!

	post: (req, res)!->
		email = JSON.parse req.body.email
		console.log email
		send-mail email.sender.email
		res.json status: \success


module.exports = {ListAdmHandler, DataListAdmHandler, UsersListAdmHandler, MailListHandler}
