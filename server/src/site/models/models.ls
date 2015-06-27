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
		name: String
		email: String
		phone: String
	metadata: Object

services-list =
	name: String
	link: String

ContentPage  = mongoose.model \ContentPage, new Schema abstract-page
DiffData     = mongoose.model \DiffData, new Schema diff-data
MailData     = mongoose.model \MailData, new Schema mail
ServicesList = mongoose.model \ServicesList, new Schema services-list

module.exports = {ContentPage, DiffData, MailData, ServicesList}
