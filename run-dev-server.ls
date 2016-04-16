#!/usr/bin/env ./lsc

require! \child_process : { spawn }

stdio = [ \ignore, process.stdout, process.stderr ]

with-flags = (<[ --bare --const ]> ++)

(.on \close process.exit) <|
spawn \./lsc, (with-flags <[ ./server/core/application.ls ]>), { stdio }
