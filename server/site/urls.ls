require! {
	colors
	\./handlers/main-handlers : {MainHandler, PageHandler}
}

module.exports =
	*url: \/
		handler: MainHandler

	*url: \/news/:page
		handler: PageHandler

	*url: \/services/:page
		handler: PageHandler

	*url: \/articles/:page
		handler: PageHandler

	*url: \/clients/:page
		handler: PageHandler

	# *url: \/contacts
	# 	handler: MainHandler

