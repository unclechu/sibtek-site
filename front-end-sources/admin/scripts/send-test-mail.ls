require! {
	\jquery : $
}

module.exports = !->
	$ \.js-mail-send .click (event)!->
		event.prevent-default!
		$ \.js-mail-send .add-class \loading

		type = $ @ .attr \data-type
		data =
			type: type
			phone: '+23234234'
			email: 'email@test.test'
			message: 'Это тестовое сообшение'


		ajax-params =
			method: \post
			url: \/send-email.json
			data: data
			success: (data)!->
				$ \.js-mail-send .remove-class \loading
				$ \.js-message-modal .modal \show
				console.log data
			error: (err)!->
				$ \.js-mail-send .remove-class \loading
				console.log err

		$.ajax ajax-params
