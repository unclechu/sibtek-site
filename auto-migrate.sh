#!/bin/bash
#
# Auto-migration util
#
# Author: Viacheslav Lotsmanov
# License: GNU/AGPLv3 (https://www.gnu.org/licenses/agpl-3.0.txt)

curver=$(./lsc ./server/site/migrations/version.ls -- --get-current-version)
if [ $? -ne 0 ]; then
	echo 'Get current migration version error' 1>&2
	exit 1
fi

list=$(ls -d ./server/site/migrations/*/ | sort | tail -n +$[$curver+1])
[ $? -ne 0 ] && { echo 'Something wrong...' 1>&2; exit 1; }
count=$(echo "$list" | wc -l)
[ $? -ne 0 ] && { echo 'Something wrong...' 1>&2; exit 1; }

echo 'Start auto-migration...'
echo "Migration list:
$list"

for (( i="$count"; i>=0; i-- )) do
	item=$(echo "$list" | tail -n $i | head -n 1)
	[ $? -ne 0 ] && { echo 'Something wrong...' 1>&2; exit 1; }
	[ "${item}x" == "x" ] && continue
	
	echo "Start migration '${item}'..."
	./lsc "${item%%/}/index.ls"
	[ $? -ne 0 ] && { echo 'Something wrong...' 1>&2; exit 1; }
	echo "Migration '${item}' is complete."
done

echo 'Auto-migration is complete.'
exit 0
