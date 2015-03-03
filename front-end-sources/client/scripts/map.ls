require! {
	\jquery : $
}

module.exports = !->
	<-! window.ymaps.ready

	$.ajax do
		method: \post
		url: \/get-contacts.json
		success: (data)!->
			contacts-template = ''

			for item in data
				contacts-template += "<p>#{item.value}</p>"

			coordinates = [60.967154, 69.041728]
			map-options =
				center: coordinates
				zoom: 14

			contacts-map = new ymaps.Map \map, map-options
			map-balloon-content =
				content-header: \Контакты
				content-body: contacts-template

			contacts-map.controls.add \zoomControl, { left: 15, top: 62 }
			contacts-map.controls.add \typeSelector, { left: 15, bottom: 100 }

			contacts-map.balloon.open contacts-map.get-center!, map-balloon-content
