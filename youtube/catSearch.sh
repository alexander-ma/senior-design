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
adb -s $PHONE_ID shell am start -n com.google.android.youtube/com.google.android.apps.youtube.app.WatchWhileActivity

sleep 2
adb -s $PHONE_ID shell input tap 838 125
sleep 1
searchTerm="cats"

echo $searchTerm
adb -s $PHONE_ID shell input text $searchTerm
sleep 2

adb -s $PHONE_ID shell input tap 958 1846

for i in {1..5}
do
	adb $PHONE_ID shell input swipe 500 1500 500 100 1000 #swipe
	sleep 2
done

kill ${PID}
sleep 3
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"


echo "Finished"