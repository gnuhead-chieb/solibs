#!/bin/bash

exclude="\
com/google/
kotlin/
[a-z]/
"


compiled_signature="$(jq -r .trackers[].code_signature /home/toor/ダウンロード/trackers.json | sort | uniq | sed -z "s/\n/|/g" | sed -e "s/|*$//g"  -e "s/^|*//g" -e "s/\./\//g" -e 's/\//\\\//g')|$(jq -r .path /home/toor/ダウンロード/libsmali.txt | sort | uniq | sed -z "s/\n/|/g" | sed -e "s/|*$//g" -e "s/^|*//g" -e 's/\//\\\//g')|$(echo "$exclude" | sed -z "s/\n/|/g" | sed -e "s/|*$//g" -e "s/^|*//g" -e 's/\//\\\//g')"
compiled_signature="$(echo $compiled_signature | sed -z "s/\n//g")"



scan="$(dexdump /home/toor/ダウンロード/MonsterStrike_22_2_0.apk | grep -oP "(?<=Class descriptor  : 'L).*(?=;')")"


echo "$scan" | perl -wn -e "print if ! /$compiled_signature/"

