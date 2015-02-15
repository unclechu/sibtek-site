require! {
	\jquery : $
	\./validate-fields : validate-fields
}
require \semantic


module.exports = !->
	$ \.js-add-data .click !->
		return if not validate-fields!
		data =
			type: ($ \.js-form).data \type
			subtype: ($ 'select[name="subtype"]').val!
			is-active: ($ \.is-active).parent!.has-class \checked
			name: ($ \.name).val!
			value: ($ \.value).val!
			sort: ($ \.sort).val!

		ajax-params =
			method: \post
			url: \/admin/add-data.json
			data: data
			data-type: \json
			success: (data)!->
				console.log data
				switch data.status
				| \success => window.location.pathname = \/admin
			error: (err)!->
				console.log err

		$.ajax ajax-params
