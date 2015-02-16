/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
}

module.exports.set-content-height = !->
	$ \.content-container .css \min-height, screen.height
	header-height = $ \header .height!
	content-height = $ \.content-container .height!
	$ \footer .css \top, header-height + content-height
	console.log ($ \footer).css \top
