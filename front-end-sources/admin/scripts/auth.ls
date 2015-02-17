require! {
	\jquery : $
	\./validate-fields : validate-fields
}


auth = !->
	$ \.js-login .click !->
		data =
			username: $ \.username .val!
			password: $ \.pass .val!

		console.log data
		ajax-params =
			method: \post
			url: \/login.json
			data: data
			success: (data)!->
				switch data.status
				| \success =>
					console.log data
					window.location.pathname = \admin
			error: (err)!->
				console.error err

		$.ajax ajax-params


module.exports = {auth}
