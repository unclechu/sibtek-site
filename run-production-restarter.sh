#!/bin/bash

cd "`dirname "$0"`"

while true; do
	echo 'Starting production server...'
	./run-production-server.ls
	echo 'Server fell, restarting...' 1>&2
	sleep 2
done
