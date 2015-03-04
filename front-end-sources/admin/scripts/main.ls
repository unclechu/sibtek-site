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
	\./send-test-mail : send-test-mail
	\./show-mail : show-mail
	\./add-user : add-user
	\./edit-user : edit-user
	\./ui-actions : ui-actions
	\./set-active : set-active
}

require \semantic

$ document .ready !->
	if ($ 'textarea.editor').length > 0
		CKEDITOR.replace 'editor'
	if ($ 'textarea.preview-text').length > 0
		CKEDITOR.replace 'preview'

	$.fn.CKEditorValFor = (element_id)!->
		return CKEDITOR.instances[element_id].getData();

	set-active!
	add!
	edit!
	upload!
	image-upload!
	main-image-upload!
	ui-actions!
	auth!
	add-data!
	edit-data!
	remove-list-element!
	send-test-mail!
	show-mail!
	add-user!
	edit-user!


	$ \.ui.checkbox .checkbox \check
	$ \.dropdown
		.dropdown do
			transition: 'swing down'
			on: \hover

	if $ \.js-file-ico  .length > 0
		$ \.js-file-ico .click (event)!->
			($ @).parent!.remove!


