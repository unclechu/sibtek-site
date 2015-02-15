require! {
	\jquery : $
	\./file-upload : upload
	\./image-upload : image-upload
	\./add-page : add
	\./remove-page : remove
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
	remove!
	add-data!
	$ \.ui.checkbox .checkbox \check
	$ \.dropdown  .dropdown {transition: \drop}
