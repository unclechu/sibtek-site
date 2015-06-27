#!/bin/bash

cd "`dirname "$0"`"
chown sibtek:sibtek -R .
chmod o-rwx -R .
chmod g-w -R .
chmod g+w -R ./files/
