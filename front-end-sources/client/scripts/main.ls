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
	\./sizes : {bind-index-page-top-card-size}
	\./menus : {bind-show-hide-main-menu}
	\./modals : show-modal
	\./anchors : {
		bind-up: bind-up-anchors
		bind-about-page: bind-about-page-anchors
	}
}

bind-show-hide-main-menu!
show-modal!
bind-up-anchors!
bind-about-page-anchors!

if $ \body .has-class \index-page
	bind-index-page-top-card-size!

$ window
	.on \resize, !-> $ window .trigger \scroll
	.trigger \resize

$ \.dropdown .dropdown do
	on: \hover
	transition: 'slide down'
