#!/usr/bin/env ./lsc

require! \child_process : { spawn }

stdio =
	\ignore
	process.stdout
	process.stderr

spawn do
	\./lsc,
	<[ ./server/core/application.ls --production ]>,
	{ stdio }
