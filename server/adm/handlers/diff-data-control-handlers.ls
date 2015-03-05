require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {DiffData, MailData}
	\../models/models : {User}
	\../utils : {is-auth}
	\../../core/pass : {pass-encrypt}
	\../../site/traits : {page-trait}
	request
}

contacts-types =
	phones: \Телефон
	addresses: \Адрес
	emails: 'Электронная почта'
	websites: \Веб-сайт
	others: \Другие


class AddDataHandler extends RequestHandler
	get: (req, res)!->
		return res.redirect \/admin/auth/login if not is-auth req
		type = req.params.type
		mode = \add

		(err, html)  <-! res.render 'data', {mode, menu, type, contacts-types, page-trait}
		if err then return res.send-status 500 and console.error err
		res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		data = new  DiffData req.body
		data.save (err, status)!->
			if err then res.json {status: \error} and console.error err
			res.json {status: \success}


class UpdateDataHandler extends RequestHandler
	get: (req, res)!->
		return res.redirect \/admin/auth/login if not is-auth req
		mode = \edit
		type = req.params.type
		DiffData
			.find-one do
				type: type
				_id : req.params.id
			.exec (err, diffdata)!->
				return res.send-status 500 and console.error err if not diffdata?
				res.render 'data', {mode, menu, type, contacts-types, diffdata, page-trait}, (err, html)!->
					if err then res.send-status 500 and console.error err
					res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		received = req.body.updated
		DiffData
			.where _id: req.body.id
			.setOptions overwrite: true
			.update received, (err, data)!->
				if err then return res.json {status: \error} and console.error err
				res.json {status: \success}


class AddUsersHandler extends RequestHandler
	get: (req, res)!->
		return res.redirect \/admin/auth/login if not is-auth req
		res.render 'user-add', {menu}, (err, html)!->
			if err then res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		new-user =
			username: req.body.username
			password: pass-encrypt req.body.password
		console.log new-user
		user = new User new-user
		user.save (err, status)!->
			return res.status 500 and console.error err if err?
			res.json status: \success


class UpdateUsersHandler extends RequestHandler
	get: (req, res)!->
		return res.redirect \/admin/auth/login if not is-auth req
		User
			.find-one _id: req.params.id
			.exec (err, user-data)!->
				return res.status 500 and console.error err if err?
				res.render 'user-edit', {menu, user-data}, (err, html)!->
					return res.status 500 and console.error err if err?
					res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		new-user-data =
			username: req.body.username
			password: pass-encrypt req.body.password
		User
			.where _id: req.body.id
			.setOptions overwrite: true
			.update new-user-data, (err, status)!->
				return res.status 500 and console.error err if err?
				if status is 0
					return res.json status: \not-updated
				res.json status: \success


class GetMessageHandler extends RequestHandler
	post: (req, res)!->
		MailData
			.find-one _id: req.body.id
			.exec (err, data)!->
				return res.status 500 and console.error err if err?
				res.json {data}


module.exports = {AddDataHandler, UpdateDataHandler, AddUsersHandler, UpdateUsersHandler, GetMessageHandler}
