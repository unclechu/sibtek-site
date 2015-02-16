require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../models/models : {Content-page}
}

class MainHandler extends RequestHandler
	get: (req, res)!->
		page = Content-page.find {type: \main-page}
		page.exec (err, data)!->
			res.render 'site/main.jade', {data}, (err, html)->
				if err then res.status 500 .end! and console.log err
				res.send html  .end!


class PageHandler extends RequestHandler
	get: (req, res)!->


class ListPageHandler extends RequestHandler
	get: (req, res)!->
		console.log req.params.item


class DevHandler extends RequestHandler
	get: (req, res)!->
		res.render 'site/' + req.params.template, (err, html)!->
			if err then res.status 500 .end! and console.error err
			res.send html  .end!


module.exports = {MainHandler, PageHandler, DevHandler}
