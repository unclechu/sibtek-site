require! {
	\prelude-ls : _p
	fs
	path
	colors
	util
	\../site/models/models : {ContentPage}
	\../config-parser : config
}

run-hours-to-utc = ->
	if config.GARBAGE_TIME - config.TIME_ZONE_UTC < 0
		24 - config.TIME_ZONE_UTC + config.GARBAGE_TIME
	else
		config.GARBAGE_TIME - config.TIME_ZONE_UTC

run-garbage-timer = !->
	run-time = config.GARBAGE_TIME
	error-message = "Invalid garbage time was set! Garbage collector will not run!".red
	return console.error error-message if (run-time < 0 or run-time > 24)

	# d = new Date!
	# utc-year = d.get-UTC-full-year!
	# utc-month = d.get-UTC-month!
	# utc-day = d.get-UTC-day!
	# utc-hours = d.get-UTC-hours!
	# utc-minutes = d.get-UTC-minutes!
	# utc-seconds = d.get-UTC-seconds!
	# curr-utc-msc = Date.UTC utc-year, utc-month, utc-day, utc-hours, utc-minutes, utc-seconds

	utc-run-hour = run-hours-to-utc
	console.log \Date:  utc-run-hour! - new Date!.get-UTC-hours!


run-garbage-collector = !->
	files-dir-path = path.join process.cwd! + \/files
	fs.readdir files-dir-path, (err, files)!->
		console.log 'Garbage collector run'.magenta

		ContentPage
			.find!
			.exec (err, data-list)!->
				found-files = [_p.concat [[..path for item.images], item.files, [item.main-photo]] for item in [..toJSON! for data-list]]
						|> _p.flatten
				all-db-files = [f - \/ for f in found-files
					when f?.length > 0  and not (~f?.index-of 'object')]

				for file-name in _p.difference [f for f in files when not (~f?.index-of 'keep')], all-db-files then let file-name
					fs.unlink (path.join files-dir-path, file-name), (err)!->
						return console.error "ERROR".red, err if err?
						console.log "#{file-name.yellow} was deleted as garbage file!"


module.exports = !->
	run-garbage-collector!
	run-garbage-timer!



