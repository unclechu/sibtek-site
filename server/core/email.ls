require! {
	nodemailer
	\../config-parser : config
}

transporter = nodemailer.create-transport do
	service: config.EMAIL.PROVIDER
	auth:
		user: config.EMAIL.USER
		password: config.EMAIL.PASS


module.exports = (sender, subject, html-body)!->
	mail-options =
		from: config.EMAIL.EMAIL_SENDER
		to: config.EMAIL.EMAIL_RECIPIENT
		subject: subject
		html: html-body

	transporter.send-mail mail-options, (err, info)!->
		return console.error err if err?
		console.log \email, info
