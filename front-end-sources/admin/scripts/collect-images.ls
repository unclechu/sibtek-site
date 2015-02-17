require! {
	\jquery : $
	\prelude-ls : _
}

module.exports = ->
	uploaded  = ($ \.uploaded-images).find \.js-image-elem
	if uploaded.length > 0
		[{
			path: $ x .children \.input  .children \.img-src  .val!
			is-main: if ($ x .children \.input  .children \.is-main-input .val!.to-string!) is \1 then true else false
			alt:  $ x .children \.input  .children \.img-alt  .val!
			} for x in uploaded]
	else []
