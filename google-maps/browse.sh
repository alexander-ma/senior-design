#!/bin/bash

while getopts t:s: option; do
    case $option in
        t) TIME=$OPTARG;;
        s) PHONE_ID=$OPTARG;;
    esac
done

echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}__${TIME}_${SERIAL_ID}.pcap" &
PID=$!
adb -s $PHONE_ID am start -a android.intent.action.VIEW com.google.android.apps.maps/com.google.android.maps.MapsActivity
sleep 10


for i in {1..5}
do
	adb -s $PHONE_ID input swipe 100 900 800 900 500
done

adb -s $PHONE_ID am force-stop com.google.android.apps.maps
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
