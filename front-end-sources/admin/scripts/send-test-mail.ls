require! {
	\jquery : $
}

module.exports = !->
	$ \.js-mail-send .click !->
		$ \.js-mail-send .add-class \loading

		type = $ @ .attr \data-type
		data =
			type: type
			phone: '+7asda'
			email: 'adsdsds0df@sdf.dfs'
			message: 'sdfsf'


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
