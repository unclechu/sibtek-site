#!/bin/bash
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info "Starting default back-end-gulp tasks"
if ./back-end-gulp; then
	info_inline "Default back-end-gulp tasks status:"; ok;
else err; fi
