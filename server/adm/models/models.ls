require! {
	\../../core/database : {Schema}
	mongoose
}


user-shema = new Schema do
	username: String
	password: String

user-shema.methods.validPassword = (pwd)->
	console.log pwd, @password
	@password === pwd

User = mongoose.model 'User', user-shema


module.exports = {User}
