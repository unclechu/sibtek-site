require! {
	\jquery : $
	\prelude-ls : _
	\./validate-fields : validate-fields
	\./collect-images : collect-images
	\./collect-files : collect-files

}
require \semantic


module.exports = !->
	$ \.js-add .click !->
		return if not validate-fields!

		type = ($ \.js-form).data \type
		symbol-code = $ \input.symbol-code .val!
		urlpath = ''
		switch type
		| \news => urlpath = "/news/#{$ \input.symbol-code .val!}.html"
		| otherwise => urlpath = "#{symbol-code}"

		data =
			is-active: ($ \.is-active).parent!.has-class \checked
			header : $ \input.header .val!
			seo:
				keywords: $ \input.keywords .val!
				description: $ \input.description .val!
				title: $ \input.title .val!
			urlpath: urlpath
			symbol-code: symbol-code
			files: collect-files!
			type: type
			content: $().CKEditorValFor \editor
			create-date : new Date
			last-change: new Date
			main-photo:  $ \input.main-img .val!
			images: collect-images!
			preview-text: $().CKEditorValFor \preview
			show-news: true


		ajax-params =
			method: \post
			url: \/admin/add-page.json
			data:
				data: JSON.stringify data
			data-type: \json
			success: (data)!->
				switch data.status
				| \success => window.location.pathname = "/admin/#{($ '.js-form').data 'type'}/list"
				| \error => console.error err
			error: (err)!->
				console.log err

		$.ajax ajax-params
