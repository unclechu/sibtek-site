require! {
	\jquery : $
	\./validate-fields : validate-fields
}
require \semantic


module.exports = !->
	$ \.js-add-user .click !->
		return if not validate-fields!

		data =
			username: ($ \.username).val!
			password: ($ \.pass).val!

		ajax-params =
			method: \post
			url: \/admin/add-user.json
			data: data
			data-type: \json
			success: (data)!->
				switch data.status
				| \success => window.location.pathname = "/admin/system/users/list"
			error: (err)!->
				console.log err

		$.ajax ajax-params
