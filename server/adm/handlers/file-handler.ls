require! {
	colors
	\prelude-ls : _
	\../../core/request-handler : {RequestHandler}
	\../ui-objects/menu : menu
	\../../site/models/models : {Content-page}
}


class FileUploadHandler extends RequestHandler
	post: (req, res)!->

		res.json {
			status: 'success'
			files: req.files
		}

module.exports = {FileUploadHandler}
