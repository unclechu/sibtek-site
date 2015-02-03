require! {
	colors
	\./handlers/main-handlers : {MainHandler}
}

module.exports =
	*url: \/
		handler: MainHandler
	*url: \/lol
		handler: MainHandler
