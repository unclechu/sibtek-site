require! {
	\../../core/database : {Schema}
	mongoose
	colors
	\../../core/pass : {pass-encrypt, pass-compare}
}


user-shema = new Schema do
	username: String
	password: String

user-shema.methods.validate-password = (password)->
	try
		pass-compare password, @password
	catch
		console.error "Invalid encrypted password".red
		false

User = mongoose.model 'User', user-shema

module.exports = {User}
