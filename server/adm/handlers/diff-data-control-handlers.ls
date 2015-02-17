require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {Diff-data}
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
		res.render 'admin/data', {mode, menu, type, contacts-types}, (err, html)!->
			if err then return res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
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
				res.render 'admin/data', {mode, menu, type, contacts-types, diffdata}, (err, html)!->
					if err then res.send-status 500 and console.error err
					res.send html  .end!

	post: (req, res)!->
		console.log \id, req.body.id
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
		res.render 'admin/user-add', {menu}, (err, html)!->
			if err then res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		return res.status 401  .end!




module.exports = {AddDataHandler, UpdateDataHandler, AddUsersHandler}
