require! {
	\jquery : $
}

module.exports = (fields)!->
	for item in fields
		elem = $ \input + item
		if elem.length > 0
			elem.parent!.parent!.add-class \error
			elem.blur !->
				elem.parent!.parent!.remove-class \error
			error-list.push item
