require! {
	\jquery : $
}

module.exports = !->
	$ \.js-mail-send .click !->
		$ \.js-mail-send .add-class \loading
		email =
			type: \calls
			text: 'Это тестовое письмо, которое содержит тестовое сообщение'
			sender:
				email: 'test@test.sibtek.ru'
				phone: ''

		ajax-params =
			method: \post
			url: \/admin/send-email.json
			data:
				email: JSON.stringify email
			success: (data)!->
				$ \.js-mail-send .remove-class \loading
				console.log data
			error: (err)!->
				$ \.js-mail-send .remove-class \loading
					# Error handling
				console.log err

		$.ajax ajax-params
