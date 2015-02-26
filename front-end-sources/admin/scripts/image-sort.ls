require! {
	\jquery : $
	\jquery-ui
	\jquery-ui.sortable
}


module.exports = !->
	$ \.uploaded-images
		.sortable do
			# append-to: $ \.uploaded-images
			axis: \y
			cursor: \move
