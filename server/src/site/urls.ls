require! {
	colors
	\./handlers/main-handlers : {
		MainHandler
		PageHandler
		ListPageHandler
		ContactsPageHandler
	}
	\./handlers/mail-api : {MailApiHandler}
}

module.exports =
	do
		url: \/
		handler: MainHandler
	do
		url: \/news/:page
		handler: PageHandler
	do
		url: \/services/:page
		handler: PageHandler
	do
		url: \/articles/:page
		handler: PageHandler
	do
		url: \/clients/:page
		handler: PageHandler
	do
		url: \/clients/
		handler: ListPageHandler
	do
		url: \/news/
		handler: ListPageHandler
	do
		url: \/contacts.html
		handler: ContactsPageHandler
	do
		url: \/send-email.json
		handler: MailApiHandler
	do
		url: \/get-contacts.json
		handler: ContactsPageHandler
