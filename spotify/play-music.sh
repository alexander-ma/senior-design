#!/bin/bash
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/spotify.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW "https://open.spotify.com/track/3kZC0ZmFWrEHdUCmUqlvgZ\?si\=_ZeVzH0XSL-HkJ33HNUDfw"
sleep 10
adb shell am force-stop com.spotify.music
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/spotify.pcap spotify.pcap