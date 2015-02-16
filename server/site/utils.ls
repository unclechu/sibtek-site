require! {
	path
	\./models/models : {ContentPage}
	\../config-parser : config
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
	page.exec (err, data)!->
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


classic-error-handler = (req, res)->


module.exports = {menu-handler, rel-url}
