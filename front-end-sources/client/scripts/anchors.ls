/**
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! \jquery : $

module.exports.bind-up = !->
	$ 'a[href$=#up]' .click ->
		$ 'html, body' .stop!.animate scroll-top: 0, 1000, !->
			window.location.hash = \#up
		false

module.exports.bind-about-page = !->
	$ \body.index-page
		.find 'header .menu a, .main-menu a, .top-card .sub a'
		.filter '[href$=#about]'
		.click ->
			return true if ($ \#about .length) <= 0
			$ 'html, body' .stop!.animate do
				scroll-top: ($ \#about .offset!.top), 1000, !->
					window.location.hash = \#about
			false
