require! {
	\jquery : $
}
require \semantic


module.exports = !->
	$ \.js-remove .click (event)!->
		event.prevent-default!
		ajax-params =
			method: \post
			url: \/admin/delete-page.json
			data:
				id: ($ @).data \id
			data-type: \json
			success: (data)!~>
				console.log ($ @)
				switch data.status
				| \success => ($ @).parent!.parent!.remove!
				| \error => console.error \Error!
			error: (err)!->
				console.log err

		$.ajax ajax-params
