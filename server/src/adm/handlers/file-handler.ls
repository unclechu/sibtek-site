require! {
	colors
	\../../core/request-handler : {RequestHandler}
	\../../site/models/models : {ContentPage}
}


class FileUploadHandler extends RequestHandler
	post: (req, res)!->
		# FIXME WTF?
		res.json do
			status: \success
			files: req.files


module.exports = {FileUploadHandler}
