require! {
	mongoose
	\../config-parser : config
}

mongoose.connect "mongodb://#{config.DATABASES.USER}:#{config.DATABASES.PASSWORD}@#{config.DATABASES.HOST}:#{config.DATABASES.PORT}/#{config.DATABASES.DATABASE}"
module.exports = {mongoose.Schema}
