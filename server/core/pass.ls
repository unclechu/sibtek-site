require! {
	\bcrypt-nodejs : bcrypt
}

pass-encrypt = (pass)->
	bcrypt.hashSync pass

pass-compare = (received, stored)->
	bcrypt.compareSync received, stored

module.exports = {pass-encrypt, pass-compare}
