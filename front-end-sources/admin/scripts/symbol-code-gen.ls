require! {
	\jquery : $
	path
	\prelude-ls : _p
}


module.exports = !->
	# $ \.js-set-symbol-code
	trans-enabled = true

	$.ajax do
		method: \get
		url: '/translit.json'
		success: (data)!->
			trans-json = {} <<<< data.BSI <<<<
				[' ' ' ' \— \– '.' ','] |>
					((x)-> [\-] * x.length |> _p.lists-to-obj x)
			console.log trans-json
			$ \input.header .blur !->
				new-value = ''
				if trans-enabled
					for symbol in ($ @).val!
						unless trans-json[symbol]?
							new-value += symbol
							continue
						new-value += trans-json[symbol]
					new-value = new-value
						.replace /-+/g, '-'
						.replace /[^0-9a-zA-Z-]/g, ''
					($ \input.symbol-code).val new-value

		error: (err)!->
			console.error err


