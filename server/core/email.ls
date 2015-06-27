require! {
	nodemailer
	\../config-parser : config
}

transporter = nodemailer.create-transport do
	service: config.EMAIL.PROVIDER
	auth:
		user: config.EMAIL.USER
		pass: config.EMAIL.PASS


module.exports = (subject, html-body, cb)!->
	mail-options =
		from: config.EMAIL.EMAIL_SENDER
		to: config.EMAIL.EMAIL_RECIPIENT
		subject: subject
		html: html-body
	
	transporter.send-mail mail-options, (err, info)!->
		return cb err if err?
		console.log \email, info
		cb null, info
