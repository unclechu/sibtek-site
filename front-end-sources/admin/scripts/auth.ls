require! {
	\jquery : $
	\./validate-fields : validate-fields
	\./show-error : show-error
}

auth = !->
	$ \.js-login .click !->
		($ @).add-class \loading
		data =
			username: $ \.username .val!
			password: $ \.pass .val!

		ajax-params =
			method: \post
			url: \/login.json
			data: data
			success: (data)!~>
				($ @).remove-class \loading
				switch data.status
				| \success =>
					window.location.pathname = \/admin/main-page/edit/0
				| \error =>
					console.error data.error-code, data.error-message
			error: (err)!~>
				($ @).remove-class \loading
				switch err.status
				| 401 =>
					text = 'Неверный логин/пароль!'
					show-error <[username pass]>, text
				| 400 =>
					text = 'Незаполнены поля!'
					show-error <[username pass]>, text
				| 500 =>
					text = 'Ошибка сервера!'
					show-error <[username pass]>, text

		$.ajax ajax-params


module.exports = {auth}
