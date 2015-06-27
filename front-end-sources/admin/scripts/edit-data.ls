require! {
	\jquery : $
	\prelude-ls : _
	\./validate-fields : validate-fields
	\semantic : {}
}


module.exports = !->
	
	$ \.js-edit-data-form .submit (event)!->
		event.prevent-default!
		return if not validate-fields!
		
		select-val = ($ 'select[name="subtype"]').val!?
		type = $ \.js-edit-data-form .data \type
		id = $ \.js-edit-data .attr \data-id
		
		switch type
		| \serviceslist =>
			url = "/admin/data/serviceslist/edit/#{id}"
			data =
				name: $ 'input[name=name]' .val!
				link: $ 'input[name=link]' .val!
				sort: $ 'input[name=sort]' .val!
		| otherwise =>
			url = \/admin/update-data.json
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
			data:
				updated: data
				id: id
			data-type: \json
			success: (data)!->
				switch data.status
				| \success =>
					window.location.pathname = "/admin/data/#{type}/list"
				| \error =>
					console.error \Error!
			error: (err)!->
				console.error err
		
		$.ajax ajax-params
