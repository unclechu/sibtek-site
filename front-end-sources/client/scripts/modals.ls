/*
	Nya
*/

require \semantic
require! {
	\jquery : $
}


module.exports.show-call-modal = !->
	$ \.js-call .click (event)!->
		$ \.call-form
			.modal {
				on-approve: ->
					console.log @
					$ @ .transition('shake')
					console.log \Approve!
					false
				on-deny: ->
					console.log \Deny!
					false
			}
			.modal \setting, \transition, 'horizontal flip'
			.modal \show



