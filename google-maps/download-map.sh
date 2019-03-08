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

# Download offline map from hamburger icon
adb shell input tap 110 183
adb shell input tap 463 1670
adb shell input tap 580 360
adb shell input tap 800 1850
sleep 20


adb shell am force-stop com.google.android.apps.maps
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull "/sdcard/${dir_name}_${script_name}__${TIME}_${SERIAL_ID}.pcap"
