require! {
	colors
	\./handlers/main-handlers : {MainHandler, PageHandler}
}

module.exports =
	*url: \/
		handler: MainHandler
	*url: \/services/:item
		handler: PageHandler

