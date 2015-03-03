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
	$ window .scroll !->
		if $ \body .width! <= 920px
			unless $ \.right-menu-opener .has-class \visible
				$ \.right-menu-opener .add-class \visible
				$ \.js-fixed-main-menu .add-class \hidden
				$ '.right-menu-opener > i' .add-class \inverted

			return unless $ \body .has-class \index-page
			if $ document .scroll-top! >= $(\.top-card).height!
				$ \.right-menu-opener .remove-class \hideout
			else
				$ \.right-menu-opener .add-class \hideout
				$ \.js-fixed-main-menu .add-class \hidden
				$ '.right-menu-opener > i' .add-class \inverted
		else
			$ \.right-menu-opener .remove-class \visible

			unless $ \body .has-class \index-page
				$ \.js-fixed-main-menu .remove-class \hidden
				return

			if $ document .scroll-top! >= $(\.top-card).height!
				$ \.js-fixed-main-menu .remove-class \hidden
			else
				$ \.js-fixed-main-menu .add-class \hidden

	$ \.right-menu-opener .click ->
		$ \.js-fixed-main-menu .toggle-class \hidden
		$ '.right-menu-opener > i' .toggle-class \inverted
		false
