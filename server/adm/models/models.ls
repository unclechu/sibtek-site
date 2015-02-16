require! {
	\../../core/database : {Schema}
	mongoose
}

user =
	username: String
	password: String

User = mongoose.model 'User', new Schema user

module.exports = {User}
