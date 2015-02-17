/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require \semantic
require! \jquery : $

<-! $ # dom ready

require! {
	\./sizes : {set-content-height}
	\./menus : {bind-show-hide-main-menu, bind-main-menu-scroll-to-anchor}
	\./modals : {show-call-modal}
}

#set-content-height!
bind-show-hide-main-menu!
bind-main-menu-scroll-to-anchor!
show-call-modal!

$ window
	.on \resize, !-> $ window .trigger \scroll
	.trigger \resize

$ \.dropdown .dropdown do
	on: \hover
	transition: 'slide down'
