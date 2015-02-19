require! {
	\../../core/database : {Schema}
	mongoose
}

abstract-page =
	type: String
	is-active: Boolean
	header: String
	seo:
		keywords: String
		description: String
		title: String
	symbol-code: String
	urlpath: String
	files: Array
	content: String
	create-date: Date
	last-change: Date
	pub-date: Date
	images: Array
	preview-text: String
	main-photo: String
	show-news: Boolean
	metadata: Object


diff-data =
	type: String
	subtype: String
	human-readable: String
	name: String
	value: String
	sort: Number
	metadata: Object

mail =
	type: String
	send-date: Date
	text: String
	sender:
		email: String
		phone: String
	metadata: Object


Content-page = mongoose.model 'ContentPage', new Schema abstract-page
Diff-data = mongoose.model 'DiffData', new Schema diff-data
Mail-data = mongoose.model 'MailData', new Schema mail

module.exports = {Content-page, Diff-data, Mail-data}
