var yaml, fs, getConfig;
yaml = require('js-yaml');
fs = require('fs');
getConfig = function(){
  var path, e;
  path = process.cwd() + '/config.yaml';
  try {
    return yaml.safeLoad(fs.readFileSync(path, 'utf8'));
  } catch (e$) {
    e = e$;
    console.log(e);
    return {};
  }
};
module.exports = getConfig();