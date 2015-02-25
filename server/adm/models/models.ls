require! {
	\../../core/database : {Schema}
	mongoose

}

user-shema = new Schema do
	username: String
	password: String

user-shema.methods.validate-password = (password)->
	true

User = mongoose.model 'User', user-shema

module.exports = {User}
