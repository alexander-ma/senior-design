#!/bin/bash

platform-tools/adb.exe shell am start -n com.snapchat.android/com.snapchat.android.LandingPageActivity
sleep 2

declare -a array=("user1" "user2" "user3")
for element in ${array[@]}
do
    sleep 1
    platform-tools/adb.exe shell input tap 266 133
    echo Add friend $element
    sleep 1
    platform-tools/adb.exe shell input text $element
    sleep 1
    echo tap add
    platform-tools/adb.exe shell input tap 859 358
    sleep 1
    echo tap clear
    platform-tools/adb.exe shell input tap 1006 123

done

echo "Finished"
