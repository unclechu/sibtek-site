require! {
	\./handlers/main-adm-handler : {MainAdmHandler}
	\./handlers/list-handlers : {
		ListAdmHandler
		DataListAdmHandler
		UsersListAdmHandler
		MailListHandler
		DeleteListElementHandler
	}
	\./handlers/content-control-handlers : {AddPageHandler, UpdatePageHandler}
	\./handlers/diff-data-control-handlers : {
		AddDataHandler
		UpdateDataHandler
		AddUsersHandler
		UpdateUsersHandler
		GetMessageHandler
	}
	\./handlers/file-handler : {FileUploadHandler}
	\./handlers/adm-auth : {AuthHandler}
	\./handlers/services-list : {
		ListServicesHandler
		AddServiceHandler
		UpdateServiceHandler
	}
}

module.exports =
	do
		url: \/
		handler: MainAdmHandler
	#============================================
	do
		url: \/data/serviceslist/list/
		handler: ListServicesHandler
	do
		url: \/data/serviceslist/add/
		handler: AddServiceHandler
	do
		url: \/data/serviceslist/edit/:id
		handler: UpdateServiceHandler
	#============================================
	do
		url: \/:type/list/
		handler: ListAdmHandler
	do
		url: \/:type/add/
		handler: AddPageHandler
	do
		url: \/:type/edit/:id
		handler: UpdatePageHandler
	do
		url: \/file-upload
		handler: FileUploadHandler
	#============================================
	do
		url: \/data/:type/list
		handler: DataListAdmHandler
	do
		url: \/data/:type/add
		handler: AddDataHandler
	do
		url: \/data/:type/edit/:id
		handler: UpdateDataHandler
	#============================================
	do
		url: \/element/:type/delete
		handler: DeleteListElementHandler
	#============================================
	do
		url: \/system/users/list
		handler: UsersListAdmHandler
	do
		url: \/system/users/edit/:id
		handler: UpdateUsersHandler
	#============================================
	do
		url: \/emails/:type/list
		handler: MailListHandler
	#============================================
	do
		url: \/add-page.json
		handler: AddPageHandler
	do
		url: \/update-page.json
		handler: UpdatePageHandler
	do
		url: \/get-message.json
		handler: GetMessageHandler
	#============================================
	do
		url: \/add-data.json
		handler: AddDataHandler
	do
		url: \/update-list-seo-data.json
		handler: ListAdmHandler
	do
		url: \/update-data.json
		handler: UpdateDataHandler
	#============================================
	do
		url: \/system/users/add
		handler: AddUsersHandler
	do
		url: \/add-user.json
		handler: AddUsersHandler
	do
		url: \/update-user.json
		handler: UpdateUsersHandler
	#============================================
	do
		url: \/auth/login
		handler: AuthHandler
