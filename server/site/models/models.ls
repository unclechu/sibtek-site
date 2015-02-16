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
	urlpath: String
	files: Array
	content: String
	create-date: Date
	last-change: Date
	images: Array
	main-photo: String
	show-news: Boolean


diff-data =
	type: String
	subtype: String
	name: String
	value: String
	sort: Number
	metadata: Object


Content-page = mongoose.model 'ContentPage', new Schema abstract-page
Diff-data = mongoose.model 'Settings', new Schema diff-data

module.exports = {Content-page, Diff-data}
