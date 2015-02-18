require! {
	\jquery : $
	path
	\prelude-ls : _p
}


module.exports = !->
	trans-enabled = ($ \.symbol-code).attr \data-transenabled or \true
	if trans-enabled is \true
		($ \.symbol-code).prop disabled: true
		($ \.js-unset).hide!
		trans-enabled = true
	else
		($ \.symbol-code).prop disabled: false
		($ \.js-set).hide!
		($ \.symbol-code).siblings \.js-lock-icon .toggle-class 'lock unlock'
		trans-enabled = false

	$.ajax do
		method: \get
		url: '/translit.json'
		success: (data)!->

			$ \.js-symbol-code .click !->
				($ \.js-symbol-code).toggle!
				if ($ \.symbol-code).prop \disabled
					($ \.symbol-code).prop disabled: false
					trans-enabled := false
				else
					($ \.symbol-code).prop disabled: true
					trans-enabled := true
					$ \input.header .trigger \blur
				($ \.symbol-code).siblings \.js-lock-icon .toggle-class 'lock unlock'


			trans-json = {} <<<< data.BSI <<<<
				[' ' ' ' \— \– '.' ','] |>
					((x)-> [\-] * x.length |> _p.lists-to-obj x)

			$ \input.header .blur !->
				if trans-enabled
					new-value = ''
					for symbol in ($ @).val!
						unless trans-json[symbol]?
							new-value += symbol
							continue
						new-value += trans-json[symbol]
					new-value = new-value
						.replace /-+/g, '-'
						.replace /[^0-9a-zA-Z-]/g, ''
					($ \input.symbol-code).val new-value.to-lower-case!

		error: (err)!->
			console.error err


