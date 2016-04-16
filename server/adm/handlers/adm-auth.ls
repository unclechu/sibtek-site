require! {
	\../../core/request-handler : {RequestHandler}
	\../models/models : {User}
	\../utils : {has-crap}
	\../../site/traits : {page-trait}
}


class AuthHandler extends RequestHandler
	get: (req, res)!->
		data = {} <<<< {page-trait}
		
		(err, html) <-! res.render \login, data
		return if has-crap res, err
		
		res.send html .end!


module.exports = {AuthHandler}
