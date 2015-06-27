/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
}

clean-up = !->
	$ \.ui.pointing.below.label
		.text ''
		.hide!
	$ \input
		.val ''
	$ \textarea
		.val ''
		.empty!

module.exports = !->
	clean-up!
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
							name: ($ ".#{form-type}-name").val! or ''
							message: ($ \.write-to-us-form-message).val! or ''
							email: ($ ".#{form-type}-email").val! or ''
							phone: ($ \.call-me-form-phone).val! or ''
						success: (data)!~>
							($ \.js-modal-form).remove-class \loading
							switch data.status
							| \success =>
								($ \i.close.icon).trigger \click
								($ \input).val ''
							
							| \error =>
								$ "##{form-type}" .transition('shake')
								switch data.error-code
								| \invalid-fields =>
									console.log data.fields
									for k,v of data.fields
										error-text = ($ "##{form-type}").attr "data-#{v}"
										$ ".#{form-type}-#{k}"
											.closest \.field
											.add-class \error
											.end!
											.siblings \.pointing.label
											.text error-text
											.show!
											.end!
											.blur !->
												$ @
													.siblings \.pointing.label
													.hide!
													.text ''
													.closest \.field
													.remove-class \error
								
								
								| \system-fail =>
									console.log data.error-code
						
						error: (err)!->
							($ \.js-modal-form).remove-class \loading
							console.error err
					
					false
				on-deny: ->
					($ \i.close.icon).trigger \click
					($ \input).val ''
					false
			
			.modal \setting, \transition, 'horizontal flip'
			.modal \show
