#!/bin/bash
./adb shell am start -a android.intent.action.VIEW "facebook:/newsfeed"
sleep 3

for i in {1..5}
do
	./adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

./adb shell am force-stop com.facebook.katana