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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW https://drive.google.com/folderview?id=1EenyWB-DTsqGxrW2MGMMHmJ940_l7sUy
sleep 4

# Click on plus
adb -s $PHONE_ID shell input tap 962 1580
sleep 2
#Click on Upload
adb -s $PHONE_ID shell input tap 555 1370
sleep 2

#select file
num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    adb -s $PHONE_ID shell input tap 800 531
elif (( $num == 2)); then
    adb -s $PHONE_ID shell input tap 817 1014
else
    adb -s $PHONE_ID shell input tap 772 1439
fi
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