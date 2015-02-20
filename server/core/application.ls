require! {
	path
	colors
	express
	http
	passport
	\express-session : session
	\../config-parser : config
	\cookie-parser
	\body-parser
	multer
	\passport-local : {Strategy}
	\../adm/models/models : {User}
	\yargs : {argv}
	\./file-garbage-collector : garbage-collector
}

app = express!
app.engine \jade, (require \jade).__express
app.use cookie-parser!
app.use body-parser.json!
app.use session { secret: 'nya cat', saveUninitialized: true, resave: false}
app.use body-parser.urlencoded extended: true
app.use multer dest: config.UPLOAD_PATH

app.use express.static path.join process.cwd!, config.STATIC_PATH
app.use express.static path.join process.cwd!, config.UPLOAD_PATH


methods = <[get post put delete]>

create-urls = (obj, name)->
	for item in require "../#{obj.app-name}/urls"
		for method, fn of item.handler.prototype
			if method in methods then obj[method] item.url, fn

#Authetnicate {{{
#Passport for auth
app.use passport.initialize!
app.use passport.session!

passport.use new Strategy (username, password, done)!->
	console.log \username, username
	User.find-one username: username, (err, user)!->
		if err then return console.error err
		if not user
			return done null, false

		(err, res) <-! user.checkEncrypted 'password', password
		return console.error err if err?
		console.log res
		return done null, user if res
		return done null, false if not res

passport.serialize-user (user, done)!->
	done null, user.username

passport.deserialize-user (user, done)!->
	User.find-one {username: user}, (err, user)!->
		done null, user.username

app.post \/login.json, passport.authenticate(\local, {session: true}), (req, res)!->
	res.json status: \success

app.get \/logout, (req, res)!->
	req.logout!
	res.redirect \/admin/auth/login
#}}} Authenticate

init-apps = (apps)->
	for apps-item in apps
		sub-app = express!
		sub-app.set \views, path.join process.cwd!, apps-item.TEMPLATES_PATH
		sub-app.set 'view engine', 'jade'
		sub-app.app-name = apps-item.NAME
		create-urls sub-app
		app.use apps-item.ROOT_URL, sub-app

init-apps config.APPS

server-cfg = if argv.production? then config.PRODUCTION else config.DEV
{PORT, HOST} = server-cfg

http.create-server app .listen PORT, HOST, !->
	console.log "Server start on host #{HOST.to-string!.yellow} and port #{PORT.to-string!.yellow}"
	garbage-collector!

