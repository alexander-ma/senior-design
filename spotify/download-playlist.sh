#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/spotify.pcap &
PID=$!
#adb shell am start -a android.intent.action.VIEW com.spotify.android/com.spotify.app.main.MainActivity
adb shell am start -a android.intent.action.VIEW com.spotify.music/.MainActivity
sleep 5

adb shell input tap 491 1845
sleep 5

adb shell input tap 534 635
sleep 5

artist="american"

adb shell input text $artist
sleep 5

adb shell input keyevent 111
sleep 2

for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

adb shell input tap 401 554
sleep 5

for i in {1..10}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

sleep 20
adb shell am force-stop com.spotify.music
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/spotify.pcap spotify.pcap