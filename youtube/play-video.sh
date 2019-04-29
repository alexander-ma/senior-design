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

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    link="http://www.youtube.com/watch?v=4EGc3r3qni8"
elif (( $num == 2 )); then
    link="https://www.youtube.com/watch?v=qC-U5gAbMHs"
else
    link="https://www.youtube.com/watch?v=BT4RlDl7z3w"
fi

adb -s $PHONE_ID shell am start -a android.intent.action.VIEW link
sleep 10

adb -s $PHONE_ID shell am force-stop com.google.android.youtube
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10