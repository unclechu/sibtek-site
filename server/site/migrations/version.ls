/**
 * Migrations version control
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\yargs : {argv}
	\../models/models : {DiffData}
}

class IncorrectMigrationVersion extends Error
	(msg) !-> @message = if msg then msg else 'Incorrect migration version'

class IncorrectMigrationVersionInDatabase extends IncorrectMigrationVersion
	(msg) !-> @message = if msg then msg else 'Incorrect migration version in database'

class IncorrectMigrationVersionArgument extends IncorrectMigrationVersion
	(msg) !-> @message = if msg then msg else 'Incorrect migration version argument'

class IncorrectMigrationVersionToSet extends IncorrectMigrationVersionArgument
	(msg) !-> @message = if msg then msg else 'Incorrect migration version to set'

class SaveMigrationVersionError extends Error
	(msg) !-> @message = if msg then msg else 'Save migration version error'

# cb (err, last-ver=number)
get-last-migration-version = (cb) !->
	DiffData
		.find-one do
			type: \migrations
			subtype: \versions
			name: \last-version
		.exec (err, data) !->
			return (!-> cb err) |> process.next-tick if err?

			value = if data? then data.value else 0
			cur-ver = value |> parse-int _, 10
			if (cur-ver |> is-NaN) or cur-ver !~= value
				return (!-> cb new IncorrectMigrationVersionInDatabase!)
					|> process.next-tick

			(!-> cb null, cur-ver) |> process.next-tick

# cb (err, correct=boolean, last-ver=number)
check-for-correct-last-version = (ver, cb) !->
	(err, last-ver) <-! get-last-migration-version
	return (!-> cb err) |> process.next-tick if err?

	ver-to-check = ver |> parse-int _, 10
	if (ver-to-check |> is-NaN) or ver-to-check !~= ver
		return (!-> cb new IncorrectMigrationVersionArgument!)
			|> process.next-tick

	(!-> cb null, ver-to-check - 1 is last-ver, last-ver)
		|> process.next-tick

# cb (err)
set-current-migration-version = (cur-ver, cb) !->
	cur-ver-to-set = cur-ver |> parse-int _, 10
	if (cur-ver-to-set |> is-NaN) or cur-ver-to-set !~= cur-ver
		return (!-> cb new IncorrectMigrationVersionToSet!)
			|> process.next-tick

	DiffData
		.find-one do
			type: \migrations
			subtype: \versions
			name: \last-version
		.update value: cur-ver-to-set, (err, data) !->
			return (!-> cb err) |> process.next-tick if err?

			# is ok
			return (!-> cb null) |> process.next-tick if data? and data

			# not found, create new
			new DiffData do
				type: \migrations
				subtype: \versions
				name: \last-version
				value: cur-ver-to-set
			.save (err, data) !->
				return (!-> cb err) |> process.next-tick if err?
				return (!-> cb null) |> process.next-tick if data? and data
				(!-> cb new SaveMigrationVersionError!) |> process.next-tick

switch
| argv.get-current-version =>
	(err, cur-ver) <-! get-last-migration-version

	if err?
		console.error err
		process.exit 1
		return

	console.log cur-ver
	process.exit 0

| argv.set-current-version =>
	(err) <-! set-current-migration-version argv.set-current-version

	if err?
		console.error err
		process.exit 1
		return

	console.log \OK
	process.exit 0

module.exports = {
	get-last-migration-version
	check-for-correct-last-version
	set-current-migration-version

	# exceptions
	IncorrectMigrationVersion
	IncorrectMigrationVersionInDatabase
	IncorrectMigrationVersionArgument
	IncorrectMigrationVersionToSet
	SaveMigrationVersionError
}
