/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
}

module.exports = !->
	($ \.js-popup-button).click (event)!->
		event.prevent-default!
		form-type = ($ @).attr \data-form
		$ "##{form-type}"
			.modal do
				on-approve: ~>
					($ \.js-modal-form).add-class \loading
					type = if form-type is \call-me-form then \calls else \messages
					$.ajax do
						method: \post
						url: \/send-email.json
						data:
							type: type
							name: ($ \.call-me-form-name).val! or ''
							message: ($ \.call-me-form-message).val! or ''
							email: ($ \.call-me-form-email).val! or ''
							phone: ($ \.call-me-form-phone).val! or ''
						success: (data)!~>
							($ \.js-modal-form).remove-class \loading
							switch data.status
							| \success =>

								console.log data.status
							| \error =>
								$ "##{form-type}" .transition('shake')
								switch data.error-code
								| \invalid-fields =>
									console.log data.fields
								| \system-fail =>
									console.log data.error-code

						error: (err)!->
							($ \.js-modal-form).remove-class \loading
							console.error err

					false
				on-deny: ->
					($ \input).val ''

			.modal \setting, \transition, 'horizontal flip'
			.modal \show

