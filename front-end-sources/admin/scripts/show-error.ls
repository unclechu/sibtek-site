require! {
	\jquery : $
}

module.exports = (fields, message)!->
	$ \.js-error-message .show!
	$ \.error-message-text .text message
	for item in fields
		elem = $ "input.#{item}"
		if elem.length > 0
			elem.closest \.field  .add-class \error
			elem.blur !->
				$ \.js-error-message .hide!
				$ \.error-message-text .empty!
				elem.closest \.field .remove-class \error
			error-list.push item
