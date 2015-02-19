require! {
	\jquery : $
}

module.exports = !->
	$ \.js-mail-send .click !->
		$ \.js-mail-send .add-class \loading

		type = $ @ .attr \data-type
		# email =
		# 	type: type
		# 	test-flag: true
		# 	text: 'Это тестовое письмо, которое содержит тестовое сообщение'
		# 	sender:
		# 		email: 'test@test.sibtek.ru'
		# 		phone: '+7000000000000'
		# 		metadata: {}

		data =
			type: type
			phone: '+765464'
			email: 'adsdsd@sdfsdf.dfs'
			message: 'Сщщбщение'


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
					# Error handling
				console.log err

		$.ajax ajax-params
