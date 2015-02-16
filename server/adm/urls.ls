require! {
	colors
	\./handlers/main-adm-handler : {MainAdmHandler}
	\./handlers/list-handlers : {ListAdmHandler, DataListAdmHandler}
	\./handlers/content-control-handlers : {AddPageHandler, UpdatePageHandler, DeletelistElementHandler}
	\./handlers/diff-data-control-handlers : {AddDataHandler, UpdateDataHandler}
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
		handler: DataListAdmHandler

	*url: \/element/:type/delete
		handler: DeletelistElementHandler


	*url: \/add-page.json
		handler: AddPageHandler
	*url: \/update-page.json
		handler: UpdatePageHandler

	*url: \/add-data.json
		handler: AddDataHandler
	*url: \/update-data.json
		handler: UpdateDataHandler

	*url: \/login
		handler: AuthHandler
	*url: \/login.json
		handler: AuthHandler
