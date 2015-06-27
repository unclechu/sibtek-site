require! {
	\jquery : $
	\prelude-ls : _
	\./choose-main-img : choose-main
}


file-upload = ->
	
	data = new FormData
	$.each ($ \.js-photo-upload-input ).0.files, (i, file)!->
		data.append i, file
	
	ajax-params =
		method: \post
		url: \/admin/file-upload
		data: data
		cashe: false
		content-type: false
		process-data: false
		success: (data)!->
			html = ""
			for elem in _.values data.files
				
				html += """<div class='ui segment js-image-elem' data-filename='/#{elem.name}'>
						<img src='/#{elem.name}' class="uploaded-image">
						<i class='ui icon remove js-file-ico'></i>
						<div class="ui input">
							<input type="text" placeholder="Описание" class="img-alt">
							<input type="hidden" name='is-main' class="is-main-input" value='false'>
							<input type="hidden" name='src' class="img-src" value='/#{elem.name}'>
						</div>
						<br/>
						<a class="main-photo-label ui red label">Главное фото</a>
						<a class="main-photo-label-button ui teal label">Сделать главным</a>
						</div>"""
			
			$ \.uploaded-images .append html
			$ \.js-file-ico .click (event)!->
				($ @).parent!.remove!
			$ \.js-photo-upload .remove-class \loading
			choose-main!
		
		
		error: (err)!->
			$ \.js-photo-upload .remove-class \loading
			console.log err
	
	$.ajax ajax-params


module.exports = !->
	$ \.js-photo-upload .click (event)!->
		event.prevent-default!
		$ \.js-photo-upload-input .trigger \click
	
	$ \.js-photo-upload-input .change !->
		$ \.js-photo-upload .add-class \loading
		file-upload!
