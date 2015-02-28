require! {
	\jquery : $
}

module.exports = !->


	window.ymaps.ready !->

		ajax-params =
			method: \post
			url: \/get-contacts.json
			success: (data)!->
				contacts-template = ""
				console.log data
				for item in data
					contacts-template += """
					<span><b>#{item.humanReadable}</b></span>
					<p>#{item.value}</p>
					"""

				coordinates = [60.967154, 69.041728]
				map-options =
					center: coordinates,
					zoom: 14,

				contacts-map = new ymaps.Map \map, map-options
				map-balloon-content =
					contentHeader: \Контакты
					contentBody: contacts-template

				contacts-map.controls.add \zoomControl, { left: 15, top: 100 }
				contacts-map.controls.add \typeSelector, { left: 15, bottom: 100 }

				contacts-map.balloon.open contacts-map.getCenter!, map-balloon-content

		$.ajax ajax-params
