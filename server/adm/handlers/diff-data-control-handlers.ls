require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {Diff-data}
}

contacts-types =
	phone: \Телефон
	address: \Адрес

class AddDataHandler extends RequestHandler
	get: (req, res)!->
		type = req.params.type
		mode = \add
		res.render 'admin/data', {mode, menu, type, contacts-types}, (err, html)!->
			if err then res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		data = Diff-data req.body
		data.save (err, data)!->
			if err then res.json {status: \error} and console.error err
			res.json {status: \success}


class UpdateDataHandler extends RequestHandler
	get: (req, res)!->
		type = req.params.type
		mode = \edit
		res.render 'admin/edit-data', {mode, menu, type, contacts-types}, (err, html)!->
			if err then res.send-status 500 and console.error err
			res.send html  .end!

	post: (req, res)!->
		data = Diff-data req.body
		data.save (err, data)!->
			if err then res.json {status: \error} and console.error err
			res.json {status: \success}



module.exports = {AddDataHandler, UpdateDataHandler}
