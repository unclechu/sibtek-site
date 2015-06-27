/**
 * config parser
 *
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\js-yaml : yaml
	fs: {read-file-sync}
	path
}

module.exports = do ->
	file-path = path.resolve process.cwd!, \config.yaml
	
	try
		config-file-contents = read-file-sync file-path, \utf8
	catch err
		console.error 'config-parser.ls/module.exports:'.red, \
			"Read config file '#{file-path.yellow}' error:", err
		throw err
		process.exit 1
		return
	
	try
		config = yaml.safe-load config-file-contents
	catch err
		console.error 'config-parser.ls/module.exports:'.red, \
			"Parse YAML error by file '#{file-path.yellow}':", err
		throw err
		process.exit 1
		return
	
	config
