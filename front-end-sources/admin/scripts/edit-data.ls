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
			type: ''
			subtype: ''
			name: ''
			value: ''
			sort: ''
			metadata: ''


		ajax-params =
			method: \post
			url: \/admin/update-data.json
			data:
				updated: data
				id: ($ @).data \id

			data-type: \json
			success: (data)!->
				switch data.status
				| \success => window.location.pathname = "/admin/#{($ '.js-form').data 'type'}/list"
				| \error => console.error \Error!
			error: (err)!->
				console.log err

		$.ajax ajax-params
