require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {Content-page, Diff-data}
	\../utils : {is-auth}
	\../../site/traits : {page-trait}
}


class AddPageHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		type = req.params.type
		mode = \add
		res.render 'pages', {mode, menu, type, page-trait}, (err, html)!->
			if err then res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		page = new Content-page JSON.parse req.body.data
		page.save (err, data)!->
			if err then res.json {status: \error}
			res.json {status: \success}


class UpdatePageHandler extends RequestHandler
	get: (req, res)!->
		if not is-auth req then return res.redirect \/admin/auth/login
		type = req.params.type
		if type is \main-page
			page = Content-page.find {type: type}
		else
			page = Content-page.find {_id: req.params.id}
		page.exec (err, data)!->
			data = data.0
			mode = \edit
			res.render 'pages', {mode, menu, type, data, page-trait}, (err, html)!->
				if err then res.send-status 500 and console.error err
				res.send html  .end!

	post: (req, res)!->
		return (res.status 401).end! if not is-auth req
		Content-page
			.where {_id: req.body.id}
			.setOptions { overwrite: true }
			.update (JSON.parse req.body.updated), (err, data)!->
				if err then return res.json {status: \error} and console.error err
				res.json {status: \success}



module.exports = {AddPageHandler, UpdatePageHandler}
