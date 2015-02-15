require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {Content-page, Diff-data}
}


class ListAdmHandler extends RequestHandler
	get: (req, res)!->
		type = req.params.type
		data = Content-page.find {type: type}
		data.exec (err, pages)!~>
			if err then res.send-status 500 and console.error error
			res.render 'admin/list', {menu, pages, type}, (err, html)->
				if err then res.send-status 500  .end!  and console.log error
				res.send html  .end!


class ListActionsHandler extends RequestHandler
	post: (req, res)!->
		res.json {}


class DataListAdmHandler extends RequestHandler
	get: (req, res)!->
		type = req.params.type
		data = Diff-data.find!
		data.exec (err, data)!->
			if err then res.send-status 500 and console.error error
			console.log data.length
			res.render 'admin/data-list', {menu, data, type}, (err, html)->
				if err then res.send-status 500  .end! and console.error err
				res.send html  .end!



module.exports = {ListAdmHandler, DataListAdmHandler}
