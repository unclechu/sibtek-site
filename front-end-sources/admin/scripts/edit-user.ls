require! {
	\jquery : $
	\./validate-fields : validate-fields
	\./show-error : show-errors
}
require \semantic


module.exports = !->
	$ \.js-edit-user-form .submit (event)!->
		event.prevent-default!
		return if not validate-fields!
		data =
			username: ($ \.username).val!
			password: ($ \.pass).val!
			id: ($ \.js-edit-user).attr \data-id
		
		ajax-params =
			method: \post
			url: \/admin/update-user.json
			data: data
			data-type: \json
			success: (data)!->
				switch data.status
				| \success => window.location.pathname = "/admin/system/users/list"
				| \not-updated => $ \.js-message-modal .modal \show
			error: (err)!->
				console.log err
		
		$.ajax ajax-params
