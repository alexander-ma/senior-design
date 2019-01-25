#!/bin/bash
# Start tcpdump and stores pcap onto sdcard of phone
./adb.exe shell tcpdump -i any -s 0 -w /sdcard/youtube.pcap &

PID=$!

./adb.exe shell am start -a android.intent.action.VIEW "http://www.youtube.com/watch?v=4EGc3r3qni8"
sleep 20
./adb.exe shell am force-stop com.google.android.youtube

kill ${PID}

sleep 3

# Pulls from the phone to the computer 
 ./adb.exe pull /sdcard/youtube.pcap youtube.pcap
