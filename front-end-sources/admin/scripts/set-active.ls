require! {
	\jquery : $
}

module.exports = !->
	menu-elements = $ \a
	for item in menu-elements
		if (($ item).attr \href) is (window.location.pathname)
			($ item).add-class \active
