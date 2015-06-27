require! {
	path
}

is-auth = (req)->
	req.session.passport.user?

err-log = (err)!->
	console.error "admin panel error:".red, (err.stack or err)
	console.trace "admin panel error trace:".red

has-crap = (res, err, is-json=false)->
	if err?
		if is-json
			res.status 500 .json status: \error
		else
			res.send-status 500 .end!
		err-log err
		true
	else
		false

go-auth = (req, res)->
	unless is-auth req
		res.redirect \/admin/auth/login
		true
	else
		false

block-post = (req, res)->
	unless is-auth req
		res.send-status 401 .end!
		true
	else
		false

module.exports = {is-auth, err-log, go-auth, block-post, has-crap}
