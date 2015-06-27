#!/bin/bash

cd "`dirname "$0"`"
chown root:sibtek -R .
chmod o-rwx -R .
chmod g-w -R .
chmod g+w -R ./files/
