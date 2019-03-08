#!/bin/bash

echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/google-maps.pcap &
PID=$!
adb shell am start -a android.intent.action.VIEW com.google.android.apps.maps/com.google.android.maps.MapsActivity
sleep 10


for i in {1..5}
do
	adb shell input swipe 100 900 800 900 500
done

adb shell am force-stop com.google.android.apps.maps
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull "/sdcard/${dir_name}_${script_name}__${TIME}_${SERIAL_ID}.pcap"
