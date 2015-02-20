require! {
	\../../core/database : {Schema}
	mongoose

}
mongoose-encrypted = require \mongoose-encrypted  .load-types mongoose
encrypted-plugin = mongoose-encrypted.plugins.encrypted-plugin
Encrypted = mongoose.SchemaTypes.Encrypted

user-shema = new Schema do
	username: String
	password:
		type: Encrypted
		method: 'pbkdf2'
		minLength: 1
		encryptOptions:
			iterations: 20000
			keyLength: 32
			saltLength: 32

user-shema.plugin encrypted-plugin


## TODO:: Just do it - encript password
user-shema.methods.validPassword = (pwd)->
	console.log pwd, @password
	@password === pwd

User = mongoose.model 'User', user-shema


module.exports = {User}
