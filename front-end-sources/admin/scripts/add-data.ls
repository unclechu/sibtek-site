require! {
	\jquery : $
	\./validate-fields : validate-fields
}
require \semantic


module.exports = !->
	$ \.js-add-data-form .submit (event)!->
		event.prevent-default!
		return if not validate-fields!
		select-val = ($ 'select[name="subtype"]').val!?
		data =
			type: ($ \.js-add-data-form).data \type
			subtype: if select-val then ($ 'select[name="subtype"]').val! else ($ \.subtype).val!
			is-active: true
			human-readable:  ($ \.human-readable).val!
			name: ($ \.name).val!
			value: ($ \.value).val!
			sort: ($ \.sort).val!

		ajax-params =
			method: \post
			url: \/admin/add-data.json
			data: data
			data-type: \json
			success: (data)!->
				switch data.status
				| \success => window.location.pathname = "/admin/data/#{($ '.js-add-data-form').attr 'data-type'}/list"
			error: (err)!->
				console.log err

		$.ajax ajax-params
