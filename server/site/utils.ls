require! {
	path
	\./models/models : {ContentPage}
}


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
					new-item.active = if req.url.index-of(item.href) is 0 then true else false
					new-item.current = if new-item.active and item.href is req.url then true else false
					new-item.href = rel-url req.base-url, item.href
					if item.children? and item.href is '/services/'
						new-item.children ++= [{
							href: path.join(new-item.href, x.urlpath) + \.html
							title: x.header} for x in [y.toJSON! for y in data]]
					new-item
			new-menus[key] = new-menus-item
		process.next-tick !-> cb null, new-menus


classic-error-handler = (req, res)->


module.exports = {menu-handler, rel-url}
