require! {
	\jquery : $
}

module.exports = !->
	$ \.js-seo-list-form .submit (event) !->
		event.prevent-default!
		$ \.js-seo-list-form .add-class \loading

		list-page-data =
			type: \list-page
			header: $ \input.header .val!
			is-active: true
			seo:
				keywords: $ \input.keywords .val!
				description: $ \input.description .val!
				title: $ \input.title .val!
			metadata:
				type: ($ \.js-seo-list-form).attr \data-type

		ajax-params =
			method: \post
			url: \/admin/update-list-seo-data.json
			data:
				data: JSON.stringify list-page-data
			success: (data)!->
				switch data.status
				| \success =>
					text = 'Сео-данные успешно обновлены'
				| \error =>
					text = 'Произошла ошибка при обновлении данных!'

				$ \.js-modal-message .text text
				$ \.js-message-modal .modal \show

				$ \.js-seo-list-form .remove-class \loading
				console.log data
			error: (err)!->
				$ \.js-seo-list-form .remove-class \loading
				if err.status is 401
					text = 'Сбой авторизации! Пожалуйста перелогиньтесь.'
				else
					text = 'Произошла ошибка при обновлении данных!'
				$ \.js-modal-message .text text
				$ \.js-message-modal .modal \show
				console.log err

		$.ajax ajax-params
