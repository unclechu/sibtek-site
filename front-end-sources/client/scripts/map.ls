/**
 * @charset utf-8
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

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
			
			data.sort (a,b)->
				| a.sort < b.sort => -1
				| a.sort > b.sort => 1
				| _ => 0
			
			for item in data
				title = do ->
					switch item.name
					| \main-phone => \Телефон
					| \main-address => \Адрес
					| \emails => 'E-Mail адреса'
					| _ => null
				value = do ->
					switch item.name
					| \emails => item.value.replace /\n/g, \<br>
					| \other =>
						list = item.value / '\n\n'
						v = [x.replace(/\n/g, '<br>') for x in list]
						v * '</p><p style="margin-top: 10px;">'
					| _ => item.value
				if title?
					contacts-template += "<h4 style='
						margin-top: 10px;
						font-weight: bold;
						'>#{title}</h4>"
				contacts-template += '<p>&nbsp;</p>' unless title?
				contacts-template += "<p>#{value}</p>"
			
			coordinates = [60.967154, 69.041728]
			map-options =
				center: coordinates
				zoom: 14
			
			contacts-map = new ymaps.Map \map, map-options
			map-balloon-content =
				content-header: \Контакты
				content-body: contacts-template
			
			contacts-map.controls.add \zoomControl, left: 15, top: 62
			contacts-map.controls.add \typeSelector, left: 15, bottom: 100
			
			contacts-map.balloon.open contacts-map.get-center!, map-balloon-content
