/*
	Nya
*/

require! {
	\jquery : $
	\./sizes : {set-content-height}
	\./menus : {show-top-menu, scroll-to-content}
	\./modals : {show-call-modal}
}

<-! $ document .ready
set-content-height!
show-top-menu!
scroll-to-content!
show-call-modal!

$ '.special.cards .image' .dimmer {
	on: 'hover'
}

$ \.dropdown  .dropdown  {
	on: \hover
	transition: 'slide down'
}

# $ \.ui.sticky  .sticky {context: '#sticky'}
