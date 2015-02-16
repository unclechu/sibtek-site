require! {
	\jquery : $
	\prelude-ls : _
}


file-upload = ->
	data = new FormData
	$.each ($ \.js-files-input ).0.files, (i, file)!->
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
			for elem in _. values data.files
				html += """<div class='ui segment js-file-elem' data-filename='/#{elem.name}'>/#{elem.name}
						<i class='ui icon remove js-file-ico'></i></div>"""
			$ \.uploaded-files .append html
			$ \.js-file-ico .click (event)!->
				($ @).parent!.remove!
			$ \.js-files .remove-class \loading
		error: (err)!->
			$ \.js-files .add-class \loading
			console.error err

	$.ajax ajax-params


module.exports = !->
	$ \.js-files .click (event)!->
		$ \.js-files-input .trigger \click

	$ \.js-files-input .change !->
		$ \.js-files .add-class \loading
		file-upload!
