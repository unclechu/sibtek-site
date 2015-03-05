#!/bin/bash
#
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info "Auto migration start"
if ./auto-migrate.sh; then
	info_inline "Auto migration status:"; ok;
else err; fi
