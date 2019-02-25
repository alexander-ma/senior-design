#!/bin/bash
adb shell am start -a android.intent.action.VIEW "facebook:/newsfeed"
sleep 3

for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

adb shell input swipe 500 300 500 1500 1000
sleep 1

adb shell input tap 400 150
sleep 2

body="subtle"

adb shell input text $body
sleep 3

adb shell input tap 400 350
sleep 2

adb shell input tap 400 700
sleep 2

for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

# back
adb shell input tap 50 100
sleep 3

# back
adb shell input tap 50 100
sleep 3

# back
adb shell input tap 50 100
sleep 3


adb shell am force-stop com.facebook.katana