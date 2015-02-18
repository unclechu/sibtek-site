require! {
	\jquery : $
}

module.exports = ->
	required-list = <[.urlpath .title .name .value .sort .username .password .subtype .human-readable. .header]>
	error-list = []
	for item in required-list
		elem = $ \input + item
		if elem.length > 0 and elem.val! is ''
			elem.parent!.parent!.add-class \error
			elem .click !->
				elem.parent!.parent!.remove-class \error
			error-list.push item
	if error-list.length > 0 then false else true
