require! {
	colors
	util: {inspect}
	co
	\../../models/models : {ContentPage, DiffData}
	\../../../adm/models/models : {User}
	\./data
}

do-migration = !->
	console.log 'Run init migration with data:\n'.green, (inspect data).blue

	co ->*
		console.log 'User model migration...'.yellow
		for item in data.users
			console.log 'User model:'.yellow,\
				'item'.green, (inspect item).blue, 'is saving...'.green
			yield !-> (User item).save it
			console.log 'User model:'.yellow,\
				'item'.green, (inspect item).blue, 'is saved!'.green
		console.log 'User model migration is complete.'.green

		console.log 'ContentPage model migration...'.yellow
		for item in data.content-pages
			console.log 'ContentPage model:'.yellow,\
				'item'.green, (inspect item).blue, 'is saving...'.green
			yield !-> (ContentPage item).save it
			console.log 'ContentPage model:'.yellow,\
				'item'.green, (inspect item).blue, 'is saved!'.green
		console.log 'ContentPage model migration is complete.'.green

		console.log 'DiffData model migration...'.yellow
		for item in data.diff-data
			console.log 'DiffData model:'.yellow,\
				'item'.green, (inspect item).blue, 'is saving...'.green
			yield !-> (DiffData item).save it
			console.log 'DiffData model:'.yellow,\
				'item'.green, (inspect item).blue, 'is saved!'.green
		console.log 'DiffData model migration is complete.'.green

		console.log 'Init migration is complete.'.green
		process.exit 0

do-migration!
