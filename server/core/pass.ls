require! {
	\bcrypt-nodejs : bcrypt

}

pass-encrypt = (pass)->
	bcrypt.hashSync pass

pass-compare = (stored, received)->
	bcrypt.compareSync stored, received

module.exports = {pass-encrypt, pass-compare}
