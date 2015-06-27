require! {
	\../../core/request-handler : {RequestHandler}
	\../models/models : {User}
	\../utils : {has-crap}
}


class AuthHandler extends RequestHandler
	get: (req, res)!->
		(err, html) <-! res.render \login
		return if has-crap res, err
		
		res.send html .end!


module.exports = {AuthHandler}
