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
adb -s $PHONE_ID shell am start -n com.instagram.android/com.instagram.android.activity.MainTabActivity
sleep 2

adb -s $PHONE_ID shell input tap 347 1824
sleep 2
adb -s $PHONE_ID shell input tap 411 174
sleep 1
adb -s $PHONE_ID shell input tap 411 174
sleep 2
searchTerm="@dog.lovers"
adb -s $PHONE_ID shell input text $searchTerm
adb -s $PHONE_ID shell input tap 751 486
sleep 1
for i in {1..5}
do
	sleep 2
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
	sleep 1
	adb -s $PHONE_ID shell input tap 460 794
	sleep 2

	adb -s $PHONE_ID shell input tap 91 73
done


echo ${#array[@]}

adb -s $PHONE_ID shell am force-stop com.instagram.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10