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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.pinterest/.activity.PinterestActivity
sleep 2

#tap on a board
adb -s $PHONE_ID shell input tap 250 650
sleep 2

#scroll through images
for i in {1..5}
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
	sleep 1
done

# back
adb -s $PHONE_ID shell input tap 70 212
sleep 3

#tap on a board
adb -s $PHONE_ID shell input tap 750 650
sleep 2

#scroll through images
for i in {1..5}
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
	sleep 1
done

# back
adb -s $PHONE_ID shell input tap 70 212
sleep 3

adb -s $PHONE_ID shell am force-stop com.pinterest
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"