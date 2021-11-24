#!/bin/bash
APK="$1"
signatures=solibs.json

checks=$(zip -sf -r "$APK" | grep -e '\.so$' | awk -F/ '{print $NF}')


for i in `seq 0 $(($(jq -r .[].signature "$signatures" | wc -l)-1))`
do
{ echo "$checks" | grep -P $(jq -r .[$i].signature "$signatures") >/dev/null; } && { echo -e "Found!\n$(jq -r .[$i] "$signatures")\n--"; }
done
