#!/bin/bash

## License:GPLv3
##Usage:
##      1. Connect phone to adb
##      2.Run script
          ./find_missing.sh [OPTIONAL:solibs.json]
         
signatures="$1"
[ -z "$1" ] && signatures=solibs.json
echo "pm list package | grep -vo -e \"^package:\" | xargs -n 1 -P 0 pm path | grep -vo -e \"^package:\" | xargs -n 1 zip -sf -r | grep -e '\.so$' | awk -F/ '{print \$NF}'" | adb shell | sort | uniq | grep -vP $(jq -r .[].signature /home/toor/ドキュメント/solibs.json | sed -z "s/\n/|/g" | sed -e "s/|$//g")
