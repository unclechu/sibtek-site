require! {
	\jquery : $
	\jquery-colorbox
}

module.exports = !->
	options =
		opacity: 0.5
		max-width: \90%
		max-height: \90%
		fixed: true

	($ \a.gallery ).colorbox options

