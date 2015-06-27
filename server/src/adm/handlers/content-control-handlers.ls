require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {ContentPage, Diff-data}
	\../utils : {go-auth, block-post, has-crap}
	\../../site/traits : {page-trait}
}


class AddPageHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		type = req.params.type
		mode = \add
		
		(err, html) <-! res.render 'pages', {mode, menu, type, page-trait}
		return if has-crap res, err
		
		res.send html .end!
	
	post: (req, res)!->
		return if block-post req, res
		
		page = new ContentPage JSON.parse req.body.data
		
		(err, data) <-! page.save
		return if has-crap res, err, true
		
		res.json status: \success


class UpdatePageHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		type = req.params.type
		
		if type is \main-page
			page = ContentPage.find-one type: type
		else
			page = ContentPage.find-by-id req.params.id
		
		(err, data) <-! page.exec
		err = new Error 'No data' unless data?
		return if has-crap res, err
		
		mode = \edit
		
		(err, html) <-! res.render 'pages', {mode, menu, type, data, page-trait}
		return if has-crap res, err
		
		res.send html .end!
	
	post: (req, res)!->
		return if block-post req, res
		
		page = ContentPage
			.find-by-id req.body.id
			.set-options overwrite: true
		
		(err, data) <-! page.update JSON.parse req.body.updated
		return if has-crap res, err, true
		
		res.json status: \success


module.exports = {AddPageHandler, UpdatePageHandler}
