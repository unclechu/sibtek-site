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

	content = ($ 'textarea.editor').data \content
	if content
		($ 'textarea.editor').val content

	$ \.js-update .click (event)!->
		return if not validate-fields!
		data =
			is-active: ($ \.is-active).parent!.has-class \checked
			header : $ \input.header .val!
			seo:
				keywords: $ \input.keywords .val!
				description: $ \input.description .val!
				title: $ \input.title .val!
			urlpath: $ \input.urlpath .val!
			files: collect-files!
			type: ($ \.js-form).data \type
			content: $().CKEditorValFor \editor
			create-date : new Date
			last-change: new Date
			main_photo: $ \input.main-img .val!
			images: collect-images!
			show-news: true

		ajax-params =
			method: \post
			url: \/admin/update-page.json
			data:
				updated: data
				id: ($ @).data \id

			data-type: \json
			success: (data)!~>
				switch data.status
				| \success => window.location.pathname = "/admin/#{($ '.js-form').data 'type'}/list"
				| \error => console.error \Error!
			error: (err)!->
				console.log err

		$.ajax ajax-params
