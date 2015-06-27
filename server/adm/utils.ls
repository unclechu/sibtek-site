require! {
	path
}

is-auth = (req)->
	req.session.passport.user?

err-log = (err)!->
	console.error 'admin panel error:'.red, (err.stack or err)

has-crap = (res, err)!->
	if err?
		res.send-status 500 .end!
		err-log err

go-auth = (req, res)->
	unless is-auth req
		res.redirect \/admin/auth/login
		return true
	else
		return false

block-post = (req, res)->
	unless is-auth req
		res.send-status 401 .end!
		return true
	else
		return false

module.exports = {is-auth, err-log, go-auth, block-post, has-crap}
