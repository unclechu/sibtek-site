require! {
	\jquery : $
}

module.exports = !->


	window.ymaps.ready !->
		coordinates = [60.967154, 69.041728]
		map-options =
			center: coordinates,
			zoom: 14,

		contacts-map = new ymaps.Map \map, map-options

		contacts-map.controls.add \zoomControl, { left: 15, top: 100 }
		contacts-map.controls.add \typeSelector, { left: 15, bottom: 100 }

		contacts-map.balloon.open contacts-map.getCenter!, {contentHeader: \Nyanya, contentBody: 'Nya'}
