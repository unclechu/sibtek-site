require! {
	\jquery : $
	\./file-upload : upload
	\./image-upload : image-upload
	\./add-page : add
	\./delete-list-element : remove-list-element
	\./edit-page : edit
	\./add-data : add-data
	\./edit-data : edit-data
	\./auth : {auth}
	\./main-image-upload : main-image-upload
}

require \semantic

$ document .ready !->
	if ($ 'textarea.editor').length > 0
		CKEDITOR.replace 'editor'
	if ($ 'textarea.preview-text').length > 0
		CKEDITOR.replace 'preview'
		$.fn.CKEditorValFor = (element_id )!->
			return CKEDITOR.instances[element_id].getData();
	add!
	edit!
	upload!
	image-upload!
	main-image-upload!
	auth!
	add-data!
	edit-data!
	remove-list-element!

	$ \.ui.checkbox .checkbox \check
	$ \.dropdown  .dropdown {transition: \drop}

	if $ \.js-file-ico  .length > 0
		$ \.js-file-ico .click (event)!->
			($ @).parent!.remove!
