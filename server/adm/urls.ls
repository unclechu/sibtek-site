require! {
	colors
	\./handlers/main-adm-handler : {MainAdmHandler}
	\./handlers/list-handlers : {ListAdmHandler, DataListAdmHandler, UsersListAdmHandler, MailListHandler, DeletelistElementHandler}
	\./handlers/content-control-handlers : {AddPageHandler, UpdatePageHandler}
	\./handlers/diff-data-control-handlers : {AddDataHandler, UpdateDataHandler, AddUsersHandler}
	\./handlers/file-handler : {FileUploadHandler}
	\./handlers/adm-auth : {AuthHandler}

}

module.exports =
	*url: \/
		handler: MainAdmHandler

	*url: \/:type/list/
		handler: ListAdmHandler
	*url: \/:type/add/
		handler: AddPageHandler
	*url: \/:type/edit/:id
		handler: UpdatePageHandler
	*url: \/file-upload
		handler: FileUploadHandler

	*url: \/data/:type/list
		handler: DataListAdmHandler
	*url: \/data/:type/add
		handler: AddDataHandler
	*url: \/data/:type/edit/:id
		handler: UpdateDataHandler

	*url: \/element/:type/delete
		handler: DeletelistElementHandler

	*url: \/system/users/list
		handler: UsersListAdmHandler
	*url: \/emails/:type/list
		handler: MailListHandler

	*url: \/add-page.json
		handler: AddPageHandler
	*url: \/update-page.json
		handler: UpdatePageHandler

	*url: \/add-data.json
		handler: AddDataHandler
	*url: \/update-data.json
		handler: UpdateDataHandler

	*url: \/system/users/add
		handler: AddUsersHandler

	*url: \/auth/login
		handler: AuthHandler

