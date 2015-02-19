require! {
	\jquery : $
}

module.exports = !->
	$ \.js-mail-send .click !->
		email =
			type: \call
			text: 'Заказ звонка.'
			sender:
				email: ''
				phone: ''

		ajax-params =
			method: \post
			url: \/admin/send-email.json
			data:
				email: JSON.stringify email
			success: (data)!->
				console.log data
			error: (err)!->
				console.log err

		$.ajax ajax-params
