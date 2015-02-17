/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
}

module.exports.show-call-modal = !->
	$ \.js-call .click (event)!->
		$ \.call-form
			.modal do
				on-approve: ->
					console.log @
					$ @ .transition('shake')
					console.log \Approve!
					false
				on-deny: ->
					console.log \Deny!
					false
			.modal \setting, \transition, 'horizontal flip'
			.modal \show
