require! {
	\jquery : $
	\prelude-ls : _
	\./validate-fields : validate-fields
	\./collect-images : collect-images
	\./collect-files : collect-files
	\./symbol-code-gen : symbol-code-gen

}
require \semantic


module.exports = !->
	if $ \input.symbol-code .length > 0
		symbol-code-gen!

	$ \.js-add-page .click !->
		return if not validate-fields!

		if ($ 'textarea.preview-text').length > 0
			preview = $().CKEditorValFor \preview
		else
			preview = ''


		type = ($ \.js-form).data \type
		symbol-code = ($ \input.symbol-code).val! .to-lower-case!
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
			pub-date: $ \input.pub-date .val! or new Date
			main-photo:  $ \input.main-img .val!
			images: collect-images!
			preview-text: preview
			show-news: true
			metadata:
				trans-enabled: ($ \.symbol-code).prop \disabled


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
