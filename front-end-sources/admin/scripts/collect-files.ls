require! {
	\jquery : $
	\prelude-ls : _
}

module.exports = ->
	uploaded  = ($ \.uploaded-files).children!
	if uploaded.length > 0
		[$ x .data \filename for x in _.tail uploaded]
	else []
