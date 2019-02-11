#!/bin/bash
adb shell am start -n com.google.android.youtube/com.google.android.apps.youtube.app.WatchWhileActivity

sleep 2
adb shell input tap 838 125
sleep 1
searchTerm="funny"

echo $searchTerm
adb shell input text $searchTerm
sleep 2

adb shell input tap 958 1846

adb shell /data/local/tmp/mysendevent /dev/input/event2 /sdcard/youtube_scroll.txt
