require! {
	\jquery : $
}
require \semantic


module.exports = !->
	$ \.js-remove .click !->
		event.prevent-default!
		ajax-params =
			method: \post
			url: "/admin/element/#{($ @).data 'type'}/delete"
			data:
				id: ($ @).data \id
			data-type: \json
			success: (data)!~>
				console.log ($ @)
				console.log data.status
				switch data.status
				| \success => ($ @).parent!.parent!.remove!
				| \error => console.error \Error!
			error: (err)!->
				console.error err

		$.ajax ajax-params

