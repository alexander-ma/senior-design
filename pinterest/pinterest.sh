#!/bin/bash
adb shell am start -a android.intent.action.VIEW com.pinterest/.activity.PinterestActivity
sleep 2

#tap on a board
adb shell input tap 250 650
sleep 2

#scroll through images
for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

# back
adb shell input tap 70 212
sleep 3

#tap on a board
adb shell input tap 750 650
sleep 2

#scroll through images
for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

# back
adb shell input tap 70 212
sleep 3

adb shell am force-stop com.pinterest