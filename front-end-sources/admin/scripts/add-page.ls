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
		console.log
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
			main_photo:  $ \input.main-img .val!
			images: collect-images!
			show-news: true


		ajax-params =
			method: \post
			url: \/admin/add-page.json
			data:
				data: JSON.stringify data
			data-type: \json
			success: (data)!->
				console.log data
				switch data.status
				| \success => window.location.pathname = \/admin
			error: (err)!->
				console.log err

		$.ajax ajax-params
