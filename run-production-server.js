#!/usr/bin/env node
'use strict';

var
	spawn = require('child_process').spawn,
	stdio = ['ignore', process.stdout, process.stderr];

spawn('node', [
	'./server/build/core/application.js',
	'--production',
], { stdio: stdio });
