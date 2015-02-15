require! {
	path
	colors
	express
	http
	passport
	# \passport-local : {Strategy}
	\../config-parser : config
	\cookie-parser
	\body-parser
	multer
}

app = express!
app.engine \jade, (require \jade).__express
app.use cookie-parser!
app.use body-parser.json!
app.use body-parser.urlencoded {extended: true}
app.use multer { dest: config.UPLOAD_PATH}

app.use express.static path.join process.cwd!, config.STATIC_PATH
app.use express.static path.join process.cwd!, config.UPLOAD_PATH

methods = <[get post put delete]>

create-urls = (obj, name)->
	for item in require "../#{obj.app-name}/urls"
		for method, fn of item.handler.prototype
			if method in methods then obj[method] item.url, fn

init-apps = (apps)->
	for apps-item in apps
		sub-app = express!
		sub-app.set \views, path.join process.cwd!, apps-item.TEMPLATES_PATH
		sub-app.set 'view engine', 'jade'
		sub-app.app-name = apps-item.NAME
		create-urls sub-app
		app.use apps-item.ROOT_URL, sub-app

init-apps config.APPS

port = config.DEV.PORT
http.create-server app .listen port
console.log "Server start in port #{port.to-string!.yellow}".green

