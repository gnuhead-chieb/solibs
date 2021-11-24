#!/bin/bash

## License:GPLv3
##Usage:./checker.sh *.apk [OPTIONAL:solibs.json]

APK="$1"
signatures="$2"

[ -z "$2" ] && signatures=solibs.json
[ -z "$APK" ] && { echo "APK file not specified! exiting..." ; exit 0; }

checks=$(zip -sf -r "$APK" | grep -e '\.so$' | awk -F/ '{print $NF}')

for i in `seq 0 $(($(jq -r .[].signature "$signatures" | wc -l)-1))`
do
{ echo "$checks" | grep -P $(jq -r .[$i].signature "$signatures") >/dev/null; } && { echo -e "Found!\n$(jq -r .[$i] "$signatures")\n--"; }
done
