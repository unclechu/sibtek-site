require! {
	colors
	express,
	http
	\../site/urls : urls
	\../config-parser : config
}

app = express!
site = express!
app.engine \jade, (require \jade).__express

app.use \/, site
# app.use \/adm, admin

app.use express.static __dirname + config.STATIC_PATH
app.set \views, process.cwd! + \/ + config.TEMPLATES_PATH
console.log "Templates path: ", app.get \views

methods = <[get post put delete]>

create-urls = (obj)->
	for item in urls
		for method, fn of new item.handler!.__proto__
			if method in methods then obj[method] item.url, fn

create-urls site

port = config.DEV.PORT
http.createServer site .listen port
console.log "Server start in port #{port.to-string!.yellow}".green

