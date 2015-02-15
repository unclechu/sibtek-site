require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../models/models : {Page}
}

class MainHandler extends RequestHandler
	get: (req, res)!->
		res.render 'site/main.jade', {}, (err, html)->
			if err then res.status 500 .end! and console.log err
			res.send html  .end!



class PageHandler extends RequestHandler
	get: (req, res)!->



class ListPageHandler extends RequestHandler
	get: (req, res)!->
		console.log req.params.item

module.exports = {MainHandler, PageHandler}
