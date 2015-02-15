require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {Content-page}
}


class AddPageHandler extends RequestHandler
	get: (req, res)!->
		type = req.params.type
		mode = \add
		res.render 'admin/pages', {mode, menu, type}, (err, html)!->
			if err then res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		page = Content-page req.body
		page.save (err, data)!->
			if err then res.json {status: \error}
			res.json {status: \success}


class UpdatePageHandler extends RequestHandler
	get: (req, res)!->
		type = req.params.type
		if type is \main-page
			page = Content-page.find {type: type}
		else
			page = Content-page.find {_id: req.params.id}
		page.exec (err, data)!->
			data = data.0
			mode = \edit
			res.render 'admin/pages', {mode, menu, type, data}, (err, html)!->
				if err then res.send-status 500 and console.error err
				res.send html  .end!

	post: (req, res)!->
		console.log req.body.updated
		q = Content-page
			.where {_id: req.body.id}
			.setOptions { overwrite: true }
			.update req.body.updated, (err, data)!->
				if err then res.json {status: \error} and console.error err
				res.json {status: \success}


class DeletePageHandler extends RequestHandler
	post: (req, res)!->
		page = Content-page.find {_id: req.body.id}
		page.remove!
		page.exec !->
			res.json {status: \success}


module.exports = {AddPageHandler, UpdatePageHandler, DeletePageHandler}
