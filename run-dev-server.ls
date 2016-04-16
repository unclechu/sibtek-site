#!/usr/bin/env ./lsc

require! \child_process : { spawn }

stdio =
	\ignore
	process.stdout
	process.stderr

spawn \./lsc, <[ ./server/core/application.ls ]>, { stdio }
