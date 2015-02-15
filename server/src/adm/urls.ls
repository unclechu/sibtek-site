require! {
	colors
	\./handlers/main-adm-handler : {MainAdmHandler}
	\./handlers/list-handlers : {ListAdmHandler, DataListAdmHandler}
	\./handlers/content-control-handlers : {AddPageHandler, UpdatePageHandler, DeletePageHandler}
	\./handlers/diff-data-control-handlers : {AddDataHandler}
	\./handlers/file-handler : {FileUploadHandler}
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
	*url: \/:type/delete/
		handler: DeletePageHandler
	*url: \/file-upload
		handler: FileUploadHandler

	*url: \/data/:type/list
		handler: DataListAdmHandler
	*url: \/data/:type/add
		handler: AddDataHandler
	*url: \/data/:type/edit/:id
		handler: DataListAdmHandler
	*url: \/data/:type/delete/:id
		handler: DataListAdmHandler


	*url: \/add-page.json
		handler: AddPageHandler
	*url: \/delete-page.json
		handler: DeletePageHandler
	*url: \/update-page.json
		handler: UpdatePageHandler

	*url: \/add-data.json
		handler: AddDataHandler
	*url: \/delete-data.json
		handler: AddDataHandler
	*url: \/update-data.json
		handler: AddDataHandler
