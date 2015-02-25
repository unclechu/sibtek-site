require! {
	colors
	\prelude-ls : _p
	\../../core/request-handler : {RequestHandler}
	\../../core/email : send-mail
	\../models/models : {MailData}
	\../../adm/utils : {is-auth}
	\../../config-parser : config
	\../../adm/utils : {is-auth}
}


validate-fields = (data, cb)->
	switch data.type
	| \calls =>
		required = <[name phone]>
		validate = <[phone email]>
	| \messages =>
		required = <[message name]>
		validate = <[email]>

	v-patterns =
		email: /.+@.+/g
		phone: /[0-9+-]/g
	r-errors = [{"#k": \required} for k, v of data when k in required and v is '']
	v-errors = [{"#k": \incorrect} for k, v of data when k in validate and v isnt '' and not v-patterns[k].test v]

	## Order is important! Firstly validation errors, then required errors.
	errors = v-errors ++ r-errors
	if errors.length  > 0
		obj = {}
		for item in errors
			## Replace validation error key to required error key if it exist.
			obj = obj <<< item
		return cb 'Invalid data', [{"#k": v} for k,v of obj]
	cb null, null


mail-go = (data, email, res, cb)!->
	header = if data.type is \calls then config.EMAIL.HEADER_CONTENT.CALLS else config.EMAIL.HEADER_CONTENT.MESSAGES

	(err, html) <-! res.render \../mail, {email}
	if err? then console.error err

	(err, info) <-! send-mail header, html
	return cb err if err?
	cb null


class MailApiHandler extends RequestHandler
	post: (req, res)!->
		data = req.body

		(err, err-fields) <-! validate-fields data
		if err?
			return res.json do
				status: \error
				error-code: \invalid-fields
				fields: err-fields

		email =
			type: data.type
			text: data.message
			send-date: new Date
			sender:
				name: data.name
				email: data.email
				phone: data.phone
			metadata: {}

		if data.test-flag
			return mail-go data, email, res, (err)!->
				res.json status: \success

		msg = new MailData email
		msg.save (err, status)!->
			if err?
				return res.status 500  .json do
					status: \error
					error-code: \system-fail
			mail-go data, email, res, (err)!->
				res.json status: \success

module.exports = {MailApiHandler}
