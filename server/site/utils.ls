require! {
	path
	\./models/models : {ContentPage, DiffData}
	\../config-parser : config
	\./traits : {page-trait, static-url, phone-link, inspect}
}


is-active-menu-item = (url, link) ->
	active = if url.index-of(link) is 0 then true else false
	current = if active and link is url then true else false
	{active, current}


rel-url = (base-url, rel-path) ->
	return rel-path if rel-path.char-at(0) isnt '/'
	base-url = base-url or \/
	path.join base-url, rel-path.slice 1


menu-handler = (req, src-menus, cb)!->
	page = ContentPage.find type: \services
	(err, data) <-! page.exec
	return cb err if err?

	new-menus = {}
	for key, val of src-menus
		new-menus-item = []
		for item in val
			new-menus-item.push let item
				new-item = {} <<<< item

				is-active = is-active-menu-item req.url, item.href
				{new-item.active, new-item.current} = is-active

				new-item.href = rel-url req.base-url, item.href
				if item.children?
					new-item.children = []
					for child in item.children
						new-child = {} <<<< child
						new-child.title = child.title[config.LANG]
						is-active = is-active-menu-item req.url, child.href
						{new-child.active, new-child.current} = is-active
						new-item.children.push new-child
					if item.href is '/services/'
						new-item.children ++= [{
							href: path.join(new-item.href, x.urlpath) + \.html
							title: x.header} for x in [y.toJSON! for y in data]]
				new-item
		new-menus[key] = new-menus-item
	process.next-tick !-> cb null, new-menus


get-all-template-data = (req, cb)!->
	data = {} <<<< page-trait <<<< {is-main-page: false} <<<< {static-url} <<<< {phone-link}

	(err, menus) <-! get-all-menus req
	return cb err if err?
	data <<<< menu: menus

	(err, result) <-! DiffData.find type: \contacts .exec
	return cb err if err?
	contacts = {}
	for item in [y.toJSON! for y in result]
		contacts[item.subtype] ?= {}
		contacts[item.subtype][item.name] = item.value
	data <<<< {contacts}

	(err, result) <-! DiffData.find type: \others .exec
	return cb err if err?
	non-relation-data = {}
	for item in [y.toJSON! for y in result]
		non-relation-data[item.subtype] ?= {}
		non-relation-data[item.subtype][item.name] = item.value
	data <<<< {non-relation-data}

	news = ContentPage
		.find type: \news
		.sort pub-date: \desc
		.limit 3
	(err, result) <-! news.exec
	return cb err if err?
	data <<<< news: [x.toJSON! for x in result]

	process.next-tick !-> cb null, data


get-all-menus = (req, cb)!->
	menus = {}

	articles = ContentPage
		.find type: \articles
		.select 'header urlpath'
	(err, result) <-! articles.exec
	return cb err if err?
	art-menu = [{
		href: "/articles/#{x.urlpath}.html"
		title: x.header } for x in [y.toJSON! for y in result]]
	menus <<<< articles: art-menu

	(err, new-menus) <-! menu-handler req, page-trait.menu
	return cb err if err?
	menus <<<< new-menus

	process.next-tick !-> cb null, menus


classic-error-handler = (err, res, status)->
	res.status status .end "#{status}"
	console.error err


module.exports = {menu-handler, rel-url, get-all-menus, get-all-template-data, classic-error-handler}
