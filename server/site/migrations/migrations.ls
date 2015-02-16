require! {
	colors
	\prelude-ls : _
	\../models/models : {Content-page}
	\./data
}


make-migration = !->
	console.log 'Run migrations'.green
	console.log  data
	for item in data
		console.log 'item'.green, item.title, 'saved!'.green
		doc =Content-page item
		doc.save!

make-migration!
