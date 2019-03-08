#!/bin/bash

echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/google-maps.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.google.android.apps.maps/com.google.android.maps.MapsActivity
sleep 10

# Center on current location
adb shell input tap 930 1250
sleep 2

# Search for location
location="Seattle"
adb shell input tap 563 169
sleep 1
adb shell input text $location
adb shell input keyevent 66
sleep 5
adb shell input keyevent 4

# Explore Nearby, choose one of Restaurants, Coffee, or Events
possible_x=(158 408 670) 
selected_x=${possible_x[$RANDOM % ${#possible_x[@]} ]}
adb shell input tap 551 1690
adb shell input tap $selected_x 1428
sleep 5
for i in {1..5}
do
	sleep 1
	adb shell input swipe 500 1500 500 100 1000
done

adb shell am force-stop com.google.android.apps.maps
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull "/sdcard/${dir_name}_${script_name}__${TIME}_${SERIAL_ID}.pcap"
