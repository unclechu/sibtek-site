/**
 * @charset utf-8
 */

require! {
	\../../../core/pass : {pass-encrypt}
}

cur-date = new Date!

module.exports =
	content-pages:
		*type: \main-page
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
		...
	users:
		*username: \admin
			password: pass-encrypt \admin
		...
	diff-data:
		*type: \contacts
			subtype: \phones
			human-readable: 'Основной телефон'
			name: \main-phone
			value: \-
			sort: 1
		*type: \contacts
			subtype: \addresses
			human-readable: 'Основной адрес'
			name: \main-address
			value: \-
			sort: 2
