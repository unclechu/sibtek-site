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


validate-fields = (fields, cb)->
	console.log fields
	required = <[phone, message]>
	validate= [{email: /.+@.+/g}, {phone: /[0-9+-]/g}]
	r-errors = [x for x in fields when x in required and x is '']

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
		return (res.status 401).end! if not is-auth req
		data = req.body
		(err, err-fields) <-! validate-fields data
		if err?
			return res.status 500  .json do
				status: \error

		email =
			type: data.type
			text: data.message
			send-date: new Date
			sender:
				email: data.email
				phone: data.phone
			metadata: {}

		if data.test-flag
			return mail-go data, email, res, (err)!->
				res.json status: \success

		msg = MailData email
		msg.save (err, status)!->
			if err?
				return res.status 500  .json do
					status: \error
					error-code: \system-fail
			mail-go data, email, res, (err)!->
				res.json status: \success

# {
# "status": "error",
# "fields": [
# {"name": "required"}
# {"email": "incorrect"}
# ]
# }
module.exports = {MailApiHandler}
