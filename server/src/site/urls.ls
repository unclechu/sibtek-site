require! {
	colors
	\./handlers/main-handlers : {MainHandler, DevHandler}
}

module.exports =
	*url: \/
		handler: MainHandler
	*url: \/lol
		handler: MainHandler
	*url: \/test/:template
		handler: DevHandler
