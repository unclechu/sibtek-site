#!/usr/bin/env iojs
'use strict';

var spawn = require('child_process').spawn;

spawn('iojs', [
	'./node_modules/.bin/lsc',
	'./server/core/application.ls',
	'--',
	'--production'
], {
	stdio: [null, process.stdout, process.stderr]
});
