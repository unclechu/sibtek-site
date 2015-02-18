require! {
	\jquery : $
}
require \semantic


module.exports = !->
	$ \.js-remove .click (event)!->
		event.prevent-default!

		ajax-params =
			method: \post
			url: "/admin/element/#{($ @).data 'type'}/delete"
			data:
				id: ($ @).data \id
			data-type: \json
			success: (data)!~>
				switch data.status
				| \success => ($ @).parent!.parent!.remove!
				| \error => console.error \Error!
			error: (err)!->
				console.error err

		$ \.modal.js-remove-modal
			.modal do
				closable: false
				on-deny: ->
				on-approve: !->
					console.log \approved
					$.ajax ajax-params
			.modal \show
