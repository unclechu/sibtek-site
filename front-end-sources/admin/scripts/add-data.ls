require! {
	\jquery : $
	\./validate-fields : validate-fields
	\semantic : {}
}


module.exports = !->
	$ \.js-add-data-form .submit (event)!->
		event.prevent-default!
		return if not validate-fields!
		
		select-val = $ 'select[name="subtype"]' .val!?
		type = $ \.js-add-data-form .data \type
		
		switch type
		| \serviceslist =>
			url = \/admin/data/serviceslist/add
			data =
				name: $ 'input[name=name]' .val!
				link: $ 'input[name=link]' .val!
				sort: $ 'input[name=sort]' .val!
		| otherwise =>
			url = \/admin/add-data.json
			data =
				type: type
				subtype: do ->
					| select-val => $ 'select[name="subtype"]' .val!
					| otherwise => $ \.subtype .val!
				is-active: true
				human-readable: $ \.human-readable .val!
				name: $ \.name .val!
				value: $ \.value .val!
				sort: $ \.sort .val!
		
		ajax-params =
			method: \post
			url: url
			data: data
			data-type: \json
			success: (data)!->
				switch data.status
				| \success =>
					window.location.pathname = "/admin/data/#{type}/list"
			error: (err)!->
				console.error err
		
		$.ajax ajax-params
