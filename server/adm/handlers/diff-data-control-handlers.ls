require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {DiffData, MailData}
	\../models/models : {User}
	\../utils : {go-auth, block-post, has-crap}
	\../../core/pass : {pass-encrypt}
	\../../site/traits : {page-trait}
	path
}

contacts-types =
	phones    : \Телефон
	addresses : \Адрес
	emails    : 'Электронная почта'
	websites  : \Веб-сайт
	others    : \Другие


class AddDataHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		type = req.params.type
		mode = \add
		
		(err, html) <-! res.render 'data', {mode, menu, type, contacts-types, page-trait}
		return if has-crap res, err
		
		res.send html .end!
		
	post: (req, res)!->
		return if block-post req, res
		
		data = new  DiffData req.body
		
		(err, status) <-! data.save
		return if has-crap res, err, true
		
		res.json status: \success


class UpdateDataHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		mode = \edit
		type = req.params.type
		
		data = DiffData.find-one do
			type: type
			_id : req.params.id
		
		(err, diffdata) <-! data.exec
		err = new Error 'No diffdata' unless diffdata?
		return if has-crap res, err
		
		(err, html) <-! res.render \data, {mode, menu, type, contacts-types, diffdata, page-trait}
		return if has-crap res, err
		
		res.send html .end!
		
	post: (req, res)!->
		return if block-post req, res
		
		received = req.body.updated
		
		data = DiffData
			.where _id: req.body.id
			.set-options overwrite: true
		
		(err, status) <-! data.update received
		return if has-crap res, err, true
		
		res.json status: \success


class AddUsersHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		(err, html) <-! res.render 'user-add', {menu}
		return if has-crap res, err
		
		res.send html .end!
		
	post: (req, res)!->
		return if block-post req, res
		
		new-user =
			username: req.body.username
			password: pass-encrypt req.body.password
		
		user = new User new-user
		
		(err, status) <-! user.save
		return if has-crap res, err, true
		
		console.info \
			'diff-data-control-handlers.ls/AddUsersHandler::post'.blue, \
			"New user added: '#{new-user.username}'"
		
		res.json status: \success


class UpdateUsersHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		user = User.find-one _id: req.params.id
		
		(err, user-data) <-! user.exec
		return if has-crap res, err
		
		(err, html) <-! res.render 'user-edit', {menu, user-data}
		return if has-crap res, err
		
		res.send html .end!
		
	post: (req, res)!->
		return if block-post req, res
		
		new-user-data =
			username: req.body.username
			password: pass-encrypt req.body.password
		
		user = User
			.where _id: req.body.id
			.set-options overwrite: true
		
		(err, status) <-! user.update new-user-data
		return if has-crap res, err, true
		
		if status is 0 or true
			console.error \
				'diff-data-control-handlers.ls/UpdateUsersHandler::post'.red, \
				"User by id '#{req.body.id.to-string!}' isn't updated,
				\ status is '#{status}'"
			return res.status 500 .json status: \not-updated
		
		console.info \
			'diff-data-control-handlers.ls/UpdateUsersHandler::post'.blue, \
			"User by id '#{req.body.id.to-string!}' is updated"
		
		res.json status: \success


class GetMessageHandler extends RequestHandler
	post: (req, res)!->
		data = MailData .find-one _id: req.body.id
		
		(err, data) <-! data.exec
		return if has-crap res, err, true
		
		res.json {data}


module.exports = {
	AddDataHandler
	UpdateDataHandler
	AddUsersHandler
	UpdateUsersHandler
	GetMessageHandler
}
