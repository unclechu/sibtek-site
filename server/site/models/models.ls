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


diff-data =
	type: String
	subtype: String
	human-readable: String
	name: String
	value: String
	sort: Number
	metadata: Object


Content-page = mongoose.model 'ContentPage', new Schema abstract-page
Diff-data = mongoose.model 'DiffData', new Schema diff-data

module.exports = {Content-page, Diff-data}
