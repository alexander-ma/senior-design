#!/bin/bash
adb shell am start -n com.twitter.android/com.twitter.app.main.MainActivity
sleep 5
adb shell input tap 942 1626
sleep 1
adb shell input text "Random%snumber:%s$RANDOM"
adb shell input tap 900 160
sleep 3
adb shell am force-stop com.twitter.android

# use the command below to just press the home button
# adb shell input keyevent 3