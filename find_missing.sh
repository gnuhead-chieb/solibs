#!/bin/bash

## License:GPLv3
##Usage:
##      1. Connect phone to adb
##      2.Run script
##        ./find_missing.sh [OPTIONAL:solibs.json]
         
function all_installed_apps {
signatures=solibs.json
echo "pm list package | grep -vo -e \"^package:\" | xargs -n 1 -P 0 pm path | grep -vo -e \"^package:\" | xargs -n 1 unzip -l | grep -e '\.so$' | awk -F/ '{print \$NF}'" | adb shell | sort | uniq | grep -vP $(jq -r .[].signature $signatures | sed -z "s/\n/|/g" | sed -e "s/|$//g")
}

function apk {
signatures=solibs.json
APK="$2"
[ -z "$2" ] && exit 0
zip -sf -r "$APK" | grep -e '\.so$' | awk -F/ '{print $NF}' | sort | uniq | grep -vP $(jq -r .[].signature $signatures | sed -z "s/\n/|/g" | sed -e "s/|$//g")
}

function package_name {
signatures=solibs.json
name="$2"
echo "pm path \"$name\" | grep -vo -e \"^package:\" | xargs -n 1 unzip -l | grep -e '\.so$' | awk -F/ '{print \$NF}'" | adb shell | sort | uniq | grep -vP $(jq -r .[].signature $signatures | sed -z "s/\n/|/g" | sed -e "s/|$//g")
}


case $1 in
"all" ) all_installed_apps $@ ;;
"apk" ) apk $@ ;;
"name" ) package_name $@ ;;
esac
