/**
 * Migration v2
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	colors
	util: {inspect}
	co
	\../../models/models : {DiffData}
	\./data
	\../version : {
		check-for-correct-last-version
		set-current-migration-version
	}
}

const version = 2

console.log 'Checking for last migration version...'.yellow
(err, correct, last-ver) <-! check-for-correct-last-version version

if err?
	console.error err
	console.error 'Check for last migration version error!'.red
	process.exit 1
	return

unless correct
	console.error "Cannot migrate from version #{last-ver} to #{version}!".red
	process.exit 1
	return

console.log 'Run migration from version '.green +
	last-ver.to-string!.blue + ' to '.green +
	version.to-string!.blue + ' with data:\n'.green, (inspect data).blue

co ->*
	console.log 'DiffData model migration...'.yellow
	for item in data.diff-data
		console.log 'DiffData model:'.yellow,\
			'item'.green, (inspect item).blue, 'is saving...'.green
		yield !-> (DiffData item).save it
		console.log 'DiffData model:'.yellow,\
			'item'.green, (inspect item).blue, 'is saved!'.green
	console.log 'DiffData model migration is complete.'.green

	console.log 'Set currect migration version to '.green +
		version.to-string!.blue
	yield !-> set-current-migration-version version, it
	console.log 'Current migration version updated from '.green +
		last-ver.to-string!.blue + ' to '.green + version.to-string!.blue

	console.log 'Init migration is complete.'.green
	process.exit 0
