require! {
	\../config-parser : config
	path
	fs
}

local-path = path.join process.cwd(), "static/client-localization.json"
menu-path = path.join process.cwd(), 'static/navigation.json'

page-trait =
	lang: config.LANG
	charset: 'utf-8'
	local: require(local-path)[config.LANG]
	menu: require(menu-path)[config.LANG]

revision = new Date! .get-time!

static-url = (path-to-file)->
	path.join(\/, path-to-file) + "?v=#revision"

module.exports = {page-trait, static-url}
