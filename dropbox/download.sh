#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/dropbox.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.dropbox.android/com.dropbox.android.activity.DbxMainActivity
sleep 5

# Tap on file ...
adb shell input tap 1000 1075
# Swipe up on more options
adb shell input swipe 600 1300 600 600 1000
# Tap on Export
adb shell input tap 540 1500
# Tap on Save to device
adb shell input tap 550 330
# Tap on Save
adb shell input tap 945 1830

sleep 10
adb shell am force-stop com.dropbox.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/dropbox.pcap dropbox.pcap
