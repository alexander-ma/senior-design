#!/bin/bash

while getopts t:s: option; do
    case $option in
        t) TIME=$OPTARG;;
        s) PHONE_ID=$OPTARG;;
    esac
done

echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" &
PID=$!
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.google.android.apps.maps/com.google.android.maps.MapsActivity
sleep 10

# Center on current location
adb -s $PHONE_ID shell input tap 930 1250
sleep 2

# Search for location
location="Houston"
adb -s $PHONE_ID shell input tap 563 169
sleep 1
adb -s $PHONE_ID shell input text $location
adb -s $PHONE_ID shell input keyevent 66
sleep 7

# Lookup directions
adb -s $PHONE_ID shell input tap 275 1295
sleep 2
adb -s $PHONE_ID shell input tap 175 1830
sleep 8


adb -s $PHONE_ID shell am force-stop com.google.android.apps.maps
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
