require! {
	\jquery : $
	\prelude-ls : _
	\./validate-fields : validate-fields
	\./choose-main-img : choose-main
	\./collect-images : collect-images
	\./collect-files : collect-files

}
require \semantic


module.exports = !->
	choose-main!
	type = ($ \.js-form).data \type

	content = ($ 'textarea.editor').data \content
	preview = ($ 'textarea.preview-text').data \content

	if content
		($ 'textarea.editor').val content
	if preview
		($ 'textarea.preview-text').val preview

	$ \.js-update .click (event)!->
		return if not validate-fields!

		symbol-code = $ \input.symbol-code .val!
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
			main-photo: $ \input.main-img .val!
			images: collect-images!
			preview-text: $().CKEditorValFor \preview
			show-news: true

		ajax-params =
			method: \post
			url: \/admin/update-page.json
			data:
				updated: JSON.stringify data
				id: ($ @).data \id

			data-type: \json
			success: (data)!~>
				switch data.status
				| \success => window.location.pathname = "/admin/#{($ '.js-form').data 'type'}/list"
				| \error => console.error \Error!
			error: (err)!->
				console.log err

		$.ajax ajax-params
