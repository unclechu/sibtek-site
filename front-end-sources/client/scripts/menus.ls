/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
}

module.exports.bind-show-hide-main-menu = !->
	return unless $ \body .has-class \index-page
	$ window .scroll !->
		if $ document .scroll-top! >= $(\.top-card).height!
			$ \.js-fixed-main-menu .remove-class \hidden
		else
			$ \.js-fixed-main-menu .add-class \hidden
