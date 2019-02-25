#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/dropbox.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.dropbox.android/com.dropbox.android.activity.DbxMainActivity
sleep 5

# Tap on + button
adb shell input tap 940 1790
# Tap on Upload photos or videos
adb shell input tap 540 1035
# Tap on photo or video to upload
adb shell input tap 220 600
# Tap on Upload
adb shell input tap 900 1830

sleep 20
adb shell am force-stop com.dropbox.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/dropbox.pcap dropbox.pcap
