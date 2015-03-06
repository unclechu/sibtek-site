/**
 * upload files garbage collector
 *
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\prelude-ls : {concat, flatten, difference}
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

	if run-time < 0 or run-time > 23
		return console.error \
			'file-garbage-collector.ls/run-garbage-timer():'.red, \
			'Invalid garbage time was set! Garbage collector will not run!'

	# TODO :: Correct UTC time calculating
	# d = new Date!
	# utc-year = d.get-UTC-full-year!
	# utc-month = d.get-UTC-month!
	# utc-day = d.get-UTC-day!
	# utc-hours = d.get-UTC-hours!
	# utc-minutes = d.get-UTC-minutes!
	# utc-seconds = d.get-UTC-seconds!
	# curr-utc-msc = Date.UTC utc-year, utc-month, utc-day, utc-hours, utc-minutes, utc-seconds

	utc-run-hour = run-hours-to-utc
	console.log 'file-garbage-collector.ls/run-garbage-timer():'.blue, \
		'Garbage collector run time:', (utc-run-hour! - new Date!.get-UTC-hours!)


run-garbage-collector = !->
	files-dir-path = path.resolve process.cwd!, config.UPLOAD_PATH
	fs.readdir files-dir-path, (err, files)!->
		if err?
			console.error 'file-garbage-collector.ls/run-garbage-collector():'.red, \
				"Read upload files directory '#{files-dir-path.yellow}' error:\n", err
			throw err
			process.exit 1
			return

		console.log 'file-garbage-collector.ls/run-garbage-collector():'.blue, \
			'Garbage collector run...'.magenta

		ContentPage
			.find!
			.exec (err, data-list)!->
				found-files = [concat [[..path for item.images], item.files, [item.main-photo]] for item in [..toJSON! for data-list]]
						|> flatten
				all-db-files = [f - \/ for f in found-files
					when f?.length > 0  and not (~f?.index-of 'object')]

				for file-name in difference [f for f in files when not (~f?.index-of 'keep')], all-db-files then let file-name
					file-path = path.join files-dir-path, file-name
					fs.unlink file-path, (err)!->
						if err?
							return console.error 'file-garbage-collector.ls/run-garbage-collector():'.red, \
								"Unlink file '#{file-path.yellow}' error:\n", err
						console.log 'file-garbage-collector.ls/run-garbage-collector():'.blue, \
							"File '#{file-name.yellow}' was deleted as garbage file"


module.exports = !->
	run-garbage-collector!
	run-garbage-timer!
