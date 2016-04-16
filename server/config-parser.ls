/**
 * config parser
 *
 * @author Andrew Fatkulin
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
  path
  fs: { read-file }
  bluebird: { coroutine }
  \js-yaml : yaml
  \colors/safe : c
}

module.exports = (.catch !->
  console.error (c.red 'Exit because of error:'), it
  process.exit 1
) <| (do) <| coroutine ->*

  file-path = path.resolve \config.yaml

  try
    config-file-contents = read-file-sync file-path, \utf8
  catch err
    console.error (c.red 'config-parser.ls/module.exports:'),
                  "Read config file '#{c.yellow file-path}' error:", err
    throw err

  try
    config = yaml.safe-load config-file-contents
  catch err
    console.error (c.red 'config-parser.ls/module.exports:'),
                  "Parse YAML error by file '#{c.yellow file-path}':", err
    throw err

  config
