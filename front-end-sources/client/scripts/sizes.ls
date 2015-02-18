/**
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\jquery : $
}

module.exports.bind-index-page-top-card-size = !->
	$ window .on \resize.index-page-top-card-size, !->
		module.exports.set-index-page-top-card-size!

module.exports.set-index-page-top-card-size = !->
	$ 'body.index-page .top-card' .css height: ($ \body).height!
