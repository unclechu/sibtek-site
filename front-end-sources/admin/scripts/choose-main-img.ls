require! {
	\jquery : $
}


module.exports = !->
	$ \.main-photo-label-button .click !->
		$ \.main-photo-label-button .show!
		$ \.is-main-input .val false
		($ @).hide!
		($ @).siblings \.input .children \.is-main-input  .val true
		$ \.main-img  .val {
			path: ($ @).siblings \.input .children \.img-src  .val!
			alt: ($ @).siblings \.input .children \.img-alt  .val!
		}
