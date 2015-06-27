/**
 * main application module
 *
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require \source-map-support .install!

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
	jade
}

upload-dir-path = path.resolve process.cwd!, config.UPLOAD_PATH

app = express!
app.engine \jade, jade.__express
app.use cookie-parser!
app.use body-parser.json!
app.use session do
	secret: config.SECRET_SALT
	save-uninitialized: true
	resave: false
app.use body-parser.urlencoded extended: true
app.use multer dest: upload-dir-path

app.use express.static path.resolve process.cwd!, config.STATIC_PATH
app.use express.static upload-dir-path

methods = <[get post put delete]>

create-urls = (obj, name)->
	for item in require "../#{obj.app-name}/urls"
		for method, fn of item.handler.prototype
			obj[method] item.url, fn if method in methods

do !-> # Auth stuff
	
	# passport for auth
	app.use passport.initialize!
	app.use passport.session!
	
	passport.use new Strategy (username, password, done)!->
		User.find-one username: username, (err, user)!->
			if err?
				return console.error 'application.ls/passport.use(new Strategy)/User.find-one(cb):'.red, \
					"Find user by '#{username.yellow}' username error:\n", err
			
			return done null, false unless user
			return done null, false unless user.validate-password password
			return done null, user
	
	passport.serialize-user (user, done)!->
		done null, user.username
	
	passport.deserialize-user (user, done)!->
		User.find-one username: user, (err, found-user)!->
			if err?
				return console.error 'application.ls/passport.deserialize-user(cb)/User.find-one(cb):'.red, \
					"Find user by '#{user.yellow}' username error:\n", err
			
			return done null, false unless found-user?.username?
			return done null, found-user.username
	
	app.post \/login.json, passport.authenticate(\local, session: true), (req, res)!->
		res.json status: \success
	
	app.get \/logout, (req, res)!->
		req.logout!
		res.redirect \/admin/auth/login

init-apps = (apps)->
	for apps-item in apps
		sub-app = express!
		sub-app.set \views, path.resolve process.cwd!, apps-item.TEMPLATES_PATH
		sub-app.set 'view engine', \jade
		sub-app.app-name = apps-item.NAME
		create-urls sub-app
		app.use apps-item.ROOT_URL, sub-app

init-apps config.APPS

server-cfg = if argv.production? then config.PRODUCTION else config.DEV
{PORT, HOST} = server-cfg

<-! http.create-server app .listen PORT, HOST
console.log 'application.ls/http.create-server(cb):'.blue, \
	"Server start on host #{HOST.to-string!.yellow}
	\ and port #{PORT.to-string!.yellow}"
garbage-collector!
