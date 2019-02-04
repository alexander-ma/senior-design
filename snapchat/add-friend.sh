#!/bin/bash

./adb shell am start -n com.snapchat.android/com.snapchat.android.LandingPageActivity
sleep 2

declare -a array=("user1" "user2" "user3")
for element in ${array[@]}
do
    sleep 1
    ./adb shell input tap 266 133
    echo Add friend $element
    sleep 1
    ./adb shell input text $element
    sleep 1
    echo tap add
    ./adb shell input tap 859 358
    sleep 1
    echo tap clear
    ./adb shell input tap 1006 123

done

echo "Finished"
