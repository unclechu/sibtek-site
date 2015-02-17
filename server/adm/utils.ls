require! {
	path
}

is-auth = (req)->
	req.session.passport.user?


module.exports = {is-auth}
