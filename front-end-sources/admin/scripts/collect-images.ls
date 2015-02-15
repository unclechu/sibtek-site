require! {
	\jquery : $
	\prelude-ls : _
}

module.exports = ->
	uploaded  = ($ \.uploaded-images).children!
	if uploaded.length > 0
		[{
			path: $ x .children \.input  .children \.img-src  .val!
			is-main:  $ x .children \.input  .children \.is-main-input  .val!
			alt:  $ x .children \.input  .children \.img-alt  .val!
			} for x in _.tail uploaded]
	else []
