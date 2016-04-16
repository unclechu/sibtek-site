#!/bin/bash
#
# Version: r1
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info "Installing Bower dependencies"
if node ./node_modules/.bin/bower install; then
	info_inline "Installing Bower dependencies:"; ok;
else err; fi
