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
adb -s $PHONE_ID shell am start -n com.google.android.youtube/com.google.android.apps.youtube.app.WatchWhileActivity

sleep 2
adb -s $PHONE_ID shell input tap 838 125
sleep 1

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    searchTerm="dogs"
elif (( $num == 2 )); then
    searchTerm="new york"
else
    searchTerm="cats"
fi

echo $searchTerm
adb -s $PHONE_ID shell input text $searchTerm
sleep 2

adb -s $PHONE_ID shell input tap 958 1846

num1=$((5 + RANDOM % 10))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))

for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
done

echo 'STOPPING TCPDUMP...'
adb -s $PHONE_ID shell am force-stop com.google.android.youtube
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10