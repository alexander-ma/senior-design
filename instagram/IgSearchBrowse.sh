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

num1=$((5 + RANDOM % 10))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))
echo $num1
for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
done

adb -s $PHONE_ID shell input tap 347 1824
sleep 2
adb -s $PHONE_ID shell input tap 411 174
sleep 1
adb -s $PHONE_ID shell input tap 411 174
sleep 2

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    searchTerm="@dog.lovers"
elif (( $num == 2 )); then
    searchTerm="#newyork"
else
    searchTerm="catloversclub"
fi

adb -s $PHONE_ID shell input text $searchTerm
adb -s $PHONE_ID shell input tap 751 486
sleep 1

num1=$((3 + RANDOM % 5))
num2=$((500 + RANDOM % 1000))
num3=$((2 + RANDOM % 3))

for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
	adb -s $PHONE_ID shell input tap 460 794
	sleep $num3

	adb -s $PHONE_ID shell input tap 91 73
	sleep $num3
done


echo ${#array[@]}
sleep 3
adb -s $PHONE_ID shell am force-stop com.instagram.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10