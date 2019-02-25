#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/spotify.pcap &
PID=$!

echo 'STARTING SPOTIFY...'
adb shell am start -a android.intent.action.VIEW com.spotify.music/.MainActivity
sleep 5

echo 'CLICKING SEARCH BUTTON'
adb shell input tap 491 1845
sleep 5

echo 'CLICKING SEARCH BAR'
adb shell input tap 534 635
sleep 5

query="playlist"

echo 'INPUTING QUERY'
adb shell input text $query
sleep 5

echo 'CLICKING SONG SIDEBAR OPTIONS'
adb shell input tap 980 527
sleep 5

echo 'CLICK DOWNLOAD PLAYLIST'
adb shell input tap 595 1400
echo 'DOWNLOADING PLAYLIST'
sleep 30

echo 'CLICKING SONG SIDEBAR OPTIONS'
adb shell input tap 980 527
sleep 5

echo 'CLICK REMOVE DOWNLOAD'
adb shell input tap 500 1400

sleep 5
adb shell am force-stop com.spotify.music
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/spotify.pcap spotify.pcap