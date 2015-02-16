require! {
	\jquery : $
	\./validate-fields : validate-fields
}


auth: !->
	$ \.js-login .click !->
		data =
			username: $ \username .val!
			pass: $ \pass .val!

		ajax-params =
			method: \post
			url: \/admin/login.json
			data: data
			success: (data)!->
				console.log data
			error: (err)!->
				console.error err

		$.ajax ajax-params


module.exports = {auth}
