/*
	Nya
*/


require! {
	\jquery : $
}


module.exports.set-content-height = ->
	$ \.content-container .css \min-height, screen.height
	header-height = $ \header .height!
	content-height = $ \.content-container .height!
	$ \footer .css \top, header-height + content-height
	console.log ($ \footer).css \top

