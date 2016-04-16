require! {
	mongoose
	\../config-parser : config
}

cfg = config.DATABASE
uri = \mongodb://

if not cfg.USER? and cfg.PASSWORD?
	throw new Error \
		'Database config parse error.'+
		' PASSWORD found in config but USER is not.'

if cfg.USER?
	uri += cfg.USER
	uri += ":#{cfg.PASSWORD}" if cfg.PASSWORD?
	uri += \@

uri += cfg.HOST or \localhost
uri += ":#{cfg.PORT}" if cfg.PORT?
uri += "/#{cfg.DATABASE_NAME}" if cfg.DATABASE_NAME?

mongoose.connect uri
module.exports <<< {
	model: mongoose.model.bind mongoose
	mongoose.Schema
}
