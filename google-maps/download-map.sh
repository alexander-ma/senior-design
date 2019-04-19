#!/bin/bash

while getopts t:s: option; do
    case $option in
        t) TIME=$OPTARG;;
        s) PHONE_ID=$OPTARG;;
    esac
done

script_name=`basename "$0"`
script_name=${script_name%.*h}
dir_name=`dirname "$0"`
dir_name=${dir_name:2}

echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" &
PID=$!
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.google.android.apps.maps/com.google.android.maps.MapsActivity
sleep 4

# Center on current location
adb -s $PHONE_ID shell input tap 930 1250
sleep 2

# Search for location

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    location="Seattle"
elif (( $num == 2 )); then
    location="Austin"
else
    location="Houston"
fi

adb -s $PHONE_ID shell input tap 563 169
sleep 1
adb -s $PHONE_ID shell input text $location
adb -s $PHONE_ID shell input keyevent 66
sleep 5

# Click on hamburger icon
adb -s $PHONE_ID shell input tap 110 183
sleep 2
# Click on offline maps
adb -s $PHONE_ID shell input tap 463 1670
sleep 2
# Click on Select your own map
adb -s $PHONE_ID shell input tap 500 682
sleep 2
# Click Download
adb -s $PHONE_ID shell input tap 800 1850
sleep 15
# Click on optin menu for map
adb -s $PHONE_ID shell input tap 1000 787
sleep 2
# Click on Delete
adb -s $PHONE_ID shell input tap 750 1215
sleep 2
# Click on yes
adb -s $PHONE_ID shell input tap 900 1157
sleep 20

adb -s $PHONE_ID shell am force-stop com.google.android.apps.maps
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10