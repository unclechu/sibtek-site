require! {
	\jquery : $
	\./file-upload : upload
	\./image-upload : image-upload
	\./add-page : add
	\./delete-list-element : remove-list-element
	\./edit-page : edit
	\./add-data : add-data
	\./main-image-upload : main-image-upload
}

require \semantic

$ document .ready !->
	if ($ 'textarea.editor').length > 0
		CKEDITOR.replace 'editor'
		$.fn.CKEditorValFor = (element_id )!->
			return CKEDITOR.instances[element_id].getData();
	add!
	edit!
	upload!
	image-upload!
	main-image-upload!

	add-data!

	remove-list-element!
	$ \.ui.checkbox .checkbox \check
	$ \.dropdown  .dropdown {transition: \drop}



	if $ \.js-file-ico  .length > 0
		$ \.js-file-ico .click (event)!->
			($ @).parent!.remove!
