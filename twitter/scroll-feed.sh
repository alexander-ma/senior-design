#!/bin/bash
adb shell am start -n com.twitter.android/com.twitter.app.main.MainActivity
sleep 5

for i in {1..5}
do
    # input swipe [start x] [start y] [end x] [end y] [speed]
	adb shell input swipe 500 1500 500 0 800
	sleep .5
done

adb shell am force-stop com.twitter.android