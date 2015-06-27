require! {
	\jquery : $
}

module.exports = !->
	$ \.js-view .click (event)!->
		event.prevent-default!
		$ \.js-view-modal
		.modal do
			on-approve:
				($ \.description.js-text).empty!
			on-hidden:
				($ \.description.js-text).empty!
		
		.modal \show
		
		ajax-params =
			method: \post
			url: '/admin/get-message.json'
			data:
				id: $ @ .attr \data-id
			success: (data)!->
				console.log data
				msg = data.data
				tmpl = """
				<span> <b>Дата отправления:</b> #{msg.sendDate}</span>
				<br/>
				<span> <b>Отправитель:</b> #{msg.sender.name}</span>
				<br/>
				<span> <b>Телефон:</b> #{msg.sender.phone or 'не был указан'}</span>
				<br/>
				<span> <b>Email:</b> #{msg.sender.email or 'не был указан'}</span>
				<h4>Текст сообщения</h4>
				<p>#{msg.text}</p>
				"""
				($ \.description.js-text).empty!
				($ \.description.js-text).html tmpl
			error: (err)!->
				console.error err
		
		$.ajax ajax-params
