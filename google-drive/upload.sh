#!/bin/bash

echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/google-drive.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.google.android.apps.docs/com.google.android.apps.docs.doclist.activity.DocListActivity
sleep 2

# Upload new file
adb shell input tap 935 1795
adb shell input tap 535 1705
adb shell input tap 520 520
sleep 15

adb shell am force-stop com.google.android.apps.docs
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull "/sdcard/${dir_name}_${script_name}__${TIME}_${SERIAL_ID}.pcap"
