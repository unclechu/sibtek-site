require! {
	\js-yaml : yaml
	fs
}

#Replace and using cwd
get-config = ->
	path =  process.cwd() + \/config.yaml
	try
		yaml.safeLoad fs.readFileSync path, 'utf8'
	catch e
		console.log e
		{}

module.exports = get-config!
