require! {
	colors
	\./handlers/main-handlers : {MainHandler, PageHandler, DevHandler}
}

module.exports =
	*url: \/
		handler: MainHandler
	*url: \/services/:item
		handler: PageHandler
	*url: \/dev/:template
		handler: DevHandler
