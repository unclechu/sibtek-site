require! {
	\jquery : $
	\prelude-ls : _
	\./choose-main-img : choose-main
}


file-upload = ->
	data = new FormData
	$.each ($ \.js-main-image-input).0.files, (i, file)!->
		data.append i, file
	
	ajax-params =
		method: \post
		url: \/admin/file-upload
		data: data
		cashe: false
		content-type: false
		process-data: false
		success: (data)!->
			$ \.js-change-main-image .remove-class \loading
			switch data.status
			| \success =>
				$ \img.main-photo-area .attr \src, '/' + data.files.0.name
				$ \.main-img .val data.files.0.name
		error: (err)!->
			$ \.js-change-main-image .remove-class \loading
			console.log err
	
	$.ajax ajax-params


module.exports = !->
	$ \.js-change-main-image .click (event)!->
		event.prevent-default!
		$ \input.js-main-image-input .trigger \click
	
	$ \input.js-main-image-input  .change !->
		$ \.js-change-main-image .add-class \loading
		file-upload!
