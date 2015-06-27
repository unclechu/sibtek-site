/**
 * @charset utf-8
 */

require! {
	\../../../core/pass : {pass-encrypt}
}

cur-date = new Date!

module.exports =
	content-pages:
		do
			type: \main-page
			is-active: true
			title: \main-page
			header: \-
			seo:
				keywords: ''
				description: ''
				title: \-
			urlpath: \/
			files: []
			content: \-
			create-date: cur-date
			last-change: cur-date
			images: []
			show-news: true
		do
			type: \list-page
			is-active: true
			header: 'Клиенты'
			seo:
				keywords: ''
				description: ''
				title: \-
			metadata:
				type: \clients
		do
			type: \list-page
			is-active: true
			header: 'Новости'
			seo:
				keywords: ''
				description: ''
				title: \-
			metadata:
				type: \news
		do
			type: \list-page
			is-active: true
			header: 'Контакты'
			seo:
				keywords: ''
				description: ''
				title: \-
			metadata:
				type: \contacts
		do
			type: \list-page
			is-active: true
			header: 'Егор Летов Жив!'
			seo:
				keywords: ''
				description: ''
				title: \-
			metadata:
				type: \articles
	
	users:
		do
			username: \admin
			password: pass-encrypt \admin
		...
	
	diff-data:
		do
			type: \contacts
			subtype: \phones
			human-readable: 'Основной телефон'
			name: \main-phone
			value: \-
			sort: 1
		do
			type: \contacts
			subtype: \addresses
			human-readable: 'Основной адрес'
			name: \main-address
			value: \-
			sort: 2
