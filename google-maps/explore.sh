#!/bin/bash

while getopts t:s: option; do
    case $option in
        t) TIME=$OPTARG;;
        s) PHONE_ID=$OPTARG;;
    esac
done

script_name=`basename "$0"`
script_name=${script_name::-3}
dir_name=`dirname "$0"`
dir_name=${dir_name:2}

echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" &
PID=$!
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.google.android.apps.maps/com.google.android.maps.MapsActivity
sleep 10

# Center on current location
adb -s $PHONE_ID shell input tap 930 1250
sleep 2

# Search for location
location="Seattle"
adb -s $PHONE_ID shell input tap 563 169
sleep 1
adb -s $PHONE_ID shell input text $location
adb -s $PHONE_ID shell input keyevent 66
sleep 5
adb -s $PHONE_ID shell input keyevent 4

# Explore Nearby, choose one of Restaurants, Coffee, or Events
possible_x=(158 408 670) 
selected_x=${possible_x[$RANDOM % ${#possible_x[@]} ]}
adb -s $PHONE_ID shell input tap 551 1690
adb -s $PHONE_ID shell input tap $selected_x 1428
sleep 5
for i in {1..5}
do
	sleep 1
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
done

adb -s $PHONE_ID shell am force-stop com.google.android.apps.maps
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
