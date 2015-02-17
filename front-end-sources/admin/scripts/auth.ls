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
					window.location.pathname = \/admin/main-page/edit/0
				| \error =>
					console.error data.error-code, data.error-message
			error: (err)!->
				console.error err

		$.ajax ajax-params


module.exports = {auth}
