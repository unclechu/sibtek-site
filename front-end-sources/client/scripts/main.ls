/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
	\./sizes : {set-content-height}
	\./menus : {show-top-menu, scroll-to-content}
	\./modals : {show-call-modal}
}

<-! $ # dom ready

set-content-height!
show-top-menu!
scroll-to-content!
show-call-modal!

$ '.special.cards .image' .dimmer do
	on: 'hover'

$ \.dropdown  .dropdown do
	on: \hover
	transition: 'slide down'
