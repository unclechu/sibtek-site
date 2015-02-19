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
			password: \admin
		...
