#!/bin/bash

adb shell am start -n com.instagram.android/com.instagram.android.activity.MainTabActivity
sleep 2

adb shell input tap 347 1824
sleep 2
adb shell input tap 411 174
sleep 1
adb shell input tap 411 174
sleep 2
searchTerm="@dog.lovers"
adb shell input text $searchTerm
adb shell input tap 751 486
sleep 1
for i in {1..5}
do
	sleep 2
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
	adb shell input tap 460 794
	sleep 2

	adb shell input tap 91 73
done


echo ${#array[@]}


echo "Finished"
