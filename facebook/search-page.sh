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

#search page
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW "com.facebook.katana/.LoginActivity"
sleep 2

adb -s $PHONE_ID shell input swipe 500 300 500 1500 1000
sleep 1

adb -s $PHONE_ID shell input tap 400 150
sleep 2



num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    body="subtle%asian%traits"
elif (( $num == 2 )); then
    body="cooking%swith%saisha"
else
    body="new%syork"
fi

adb -s $PHONE_ID shell input text $body
adb -s $PHONE_ID shell input keyevent 66
sleep 3

adb -s $PHONE_ID shell input tap 400 522
sleep 2

num1=$((2 + RANDOM % 5))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))

for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
done
sleep 20
echo 'STOPPING TCPDUMP...'
kill ${PID}
adb -s $PHONE_ID shell am force-stop com.facebook.katana
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10