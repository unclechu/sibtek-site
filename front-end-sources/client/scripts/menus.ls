/*
	Nya
*/


require! {
	\jquery : $
}

module.exports.show-top-menu = ->
	$ document .scroll (event)!->
		if $ document .scroll-top! > ($ \header).height! - 50
			$ \.js-static-menu .fade-in 400
		else
			$ \.js-static-menu .hide!

module.exports.scroll-to-content = ->
	$ \.js-about .click (event)->
		$ \html .animate { scroll-top: ($ \header).height! }, 600
