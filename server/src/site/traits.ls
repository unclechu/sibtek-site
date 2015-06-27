/**
 * traits module
 *
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../config-parser : config
	path
	fs
	util
}

static-path = path.resolve process.cwd!, config.STATIC_PATH
local-path  = path.resolve static-path, \localization.json
menu-path   = path.resolve static-path, \navigation.json

page-trait =
	lang    : config.LANG
	charset : 'utf-8'
	local   : require(local-path)[config.LANG]
	menu    : {}

revision = new Date! .get-time!

static-url = (path-to-file)->
	path.join \/, path-to-file |> (+ "?v=#revision")

phone-link = (phone)->
	"tel:#{phone - /[^0-9+]/g}"

inspect = (smth, opts=null)->
	util.inspect smth, opts

for key, val of require menu-path
	new-menus-item = []
	for item in val
		new-menus-item.push let item
			retval = {} <<<< item <<<< do
				title: item.title[config.LANG]
				href: item.href or null
			retval.children = [] ++ item.children if item.children?
			retval
	page-trait.menu[key] = new-menus-item

module.exports = {page-trait, static-url, phone-link, inspect}
