require! {
	colors
	\prelude-ls : _
	\../models/models : {Content-page}
	\../../adm/models/models : {User}
	\./data
}


make-migration = !->
	console.log 'Run migrations'.green
	console.log  data
	for item in data
		console.log 'item'.green, item, 'saved!'.green
		# doc = Content-page item
		doc = User item
		doc.save!

make-migration!
