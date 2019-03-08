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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.reddit.frontpage/com.reddit.frontpage.MainActivity
sleep 2

# Enter search term
adb -s $PHONE_ID shell input tap 450 170
searchTerm="dogs"
adb -s $PHONE_ID shell input text $searchTerm
adb -s $PHONE_ID shell input tap 990 1840

# Tap Posts
adb -s $PHONE_ID shell input tap 320 320

for i in {1..5}
do
	sleep 1
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
done

adb -s $PHONE_ID shell am force-stop com.reddit.frontpage
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
