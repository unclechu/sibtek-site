require! {
	\jquery : $
	\jquery-ui
	\jquery-ui.sortable
	\jquery-ui.datepicker
}


module.exports = !->
	uploaded-container = $ \.uploaded-images
	date-element = $ \#pub-date
	received-date = date-element.attr \data-date

	if uploaded-container.length > 0
		$ uploaded-container
			.sortable do
				axis: \y
				cursor: \move

	if date-element.length > 0
		date-element.datepicker!

