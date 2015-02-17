require! {
	\jquery : $
}


module.exports = !->
	$ \.main-photo-label-button .click !->
		$ \.main-photo-label-button .show!
		$ \.is-main-input .val \0
		($ @).hide!
		($ @).siblings \.input .children \.is-main-input  .val \1
		$ \.main-img  .val do
			path: ($ @).siblings \.input .children \.img-src  .val!
			alt: ($ @).siblings \.input .children \.img-alt  .val!
