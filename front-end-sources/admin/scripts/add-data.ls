require! {
	\jquery : $
	\./validate-fields : validate-fields
}
require \semantic


module.exports = !->
	$ \.js-add-data .click !->
		return if not validate-fields!
		select-val = ($ 'select[name="subtype"]').val!?
		data =
			type: ($ \.js-form).data \type
			subtype: if select-val then ($ 'select[name="subtype"]').val! else ($ \.subtype).val!
			is-active: ($ \.is-active).parent!.has-class \checked
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
				| \success => window.location.pathname = "/admin/data/#{($ '.js-form').data 'type'}/list"
			error: (err)!->
				console.log err

		$.ajax ajax-params
