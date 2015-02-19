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
	required = <[phone message]>
	validate = <[email phone]>
	v-patterns =
		email: /.+@.+/g
		phone: /[0-9+-]/g
	r-errors = [{"#k": \required} for k, v of data when k in required and v is '']
	v-errors = [{"#k": \incorrect} for k, v of data when k in validate and not v-patterns[k].test v]

	## Order is important!
	errors = v-errors ++ r-errors
	if errors.length  > 0
		obj = {}
		for item in errors
			obj = obj <<< item
		return cb 'Invalid fields', [{"#k": v} for k,v of obj]
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
		# return (res.status 401).end! if not is-auth req
		data = req.body
		(err, err-fields) <-! validate-fields data
		console.log err-fields
		if err?
			## See the http://www.bennadel.com/blog/2434-http-status-codes-for-invalid-data-400-vs-422.htm for 422 status
			return res.status 422  .json do
				status: \error
				fields: err-fields

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
