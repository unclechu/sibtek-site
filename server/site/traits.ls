require! {
	\../config-parser : config
	path
	fs
}

local-path = path.join process.cwd!, "static/client-localization.json"
menu-path = path.join process.cwd!, 'static/navigation.json'

page-trait =
	lang: config.LANG
	charset: 'utf-8'
	local: require(local-path)[config.LANG]
	menu: {}

revision = new Date! .get-time!

static-url = (path-to-file)->
	path.join(\/, path-to-file) + "?v=#revision"

for key, val of require menu-path
	new-menus-item = []
	for item in val
		new-menus-item.push let item
			retval =
				title: item.title[config.LANG]
				href: item.href or null
			if item.children?
				retval.children = [] ++ item.children
			retval
	page-trait.menu[key] = new-menus-item

console.log page-trait.menu

module.exports = {page-trait, static-url}