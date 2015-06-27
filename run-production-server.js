#!/usr/bin/env iojs
'use strict';

var
	spawn = require('child_process').spawn,
	stdio = ['ignore', process.stdout, process.stderr];

spawn('iojs', [
	'./server/build/core/application.js',
	'--production'
], { stdio: stdio });
