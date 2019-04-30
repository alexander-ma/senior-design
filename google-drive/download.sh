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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW https://drive.google.com/folderview?id=197hwpNRjYp7xJofgtaqMgYbNCmmtCsv0
sleep 4

#select file
num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    adb -s $PHONE_ID shell input tap 479 824
elif (( $num == 2)); then
    adb -s $PHONE_ID shell input tap 1009 821
else
    adb -s $PHONE_ID shell input tap 1014 1340
fi
sleep 2

#scroll to download option
adb -s $PHONE_ID shell input swipe 600 1300 600 600 200
adb -s $PHONE_ID shell input swipe 600 1300 600 600 200
sleep 2

# Tap Download
adb -s $PHONE_ID shell input tap 315 818

sleep 20

adb -s $PHONE_ID shell am force-stop com.google.android.apps.docs
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10