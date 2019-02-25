#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/reddit.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.reddit.frontpage/com.reddit.frontpage.MainActivity
sleep 2

# Create text post
adb shell input tap 550 1850
adb shell input tap 900 1650
adb shell input tap 550 340
# Choose community
adb shell input tap 550 550
adb shell input tap 550 500
postTerm="Testing"
adb shell input text $postTerm
adb shell input tap 550 650
detailText="ignore"
adb shell input text $postTerm
adb shell input tap 970 190

sleep 2
adb shell am force-stop com.reddit.frontpage
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/reddit.pcap reddit.pcap
