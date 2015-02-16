require! {
	\../config-parser : config
	path
}

page-trait =
	lang: config.LANG
	charset: 'utf-8'
	local: "/client-localization.json[#{@lang}]"
	menu:  "/navigation.json"

static-url = (path-to-file)->
	path.join '/', path-to-file

module.exports = {page-trait, static-url}

