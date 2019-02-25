#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/reddit.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.reddit.frontpage/com.reddit.frontpage.MainActivity
sleep 2

# Enter search term
adb shell input tap 450 170
searchTerm="dogs"
adb shell input text $searchTerm
adb shell input tap 990 1840

# Tap Posts
adb shell input tap 320 320

for i in {1..5}
do
	sleep 1
	adb shell input swipe 500 1500 500 100 1000
done

adb shell am force-stop com.reddit.frontpage
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/reddit.pcap reddit.pcap
