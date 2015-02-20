require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {DiffData, MailData}
	\../utils : {is-auth}
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
		res.render 'data', {mode, menu, type, contacts-types}, (err, html)!->
			if err then return res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		data = DiffData req.body
		data.save (err, data)!->
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
				res.render 'data', {mode, menu, type, contacts-types, diffdata}, (err, html)!->
					if err then res.send-status 500 and console.error err
					res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		data = DiffData
			.where {_id: req.body.id}
			.setOptions { overwrite: true }
			.update req.body.updated, (err, data)!->
				console.log data
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


class GetMessageHandler extends RequestHandler
	post: (req, res)!->
		MailData
			.find-one _id: req.body.id
			.exec (err, data)!->
				return res.send-status 500 and console.error err if err?
				res.json {data}


module.exports = {AddDataHandler, UpdateDataHandler, AddUsersHandler, GetMessageHandler}
