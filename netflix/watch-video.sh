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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.netflix.mediaclient/.ui.launch.UIWebViewActivity
sleep 10

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    num1="220"
elif (( $num == 2 )); then
    num1="530"
else
    num1="820"
fi
num1="220"
### START ACTIONS HERE
adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
sleep 2
adb -s $PHONE_ID shell input tap $num1 420
sleep 2
adb -s $PHONE_ID shell input tap 540 1720
sleep 20

### END ACTIONS HERE

adb -s $PHONE_ID shell am force-stop com.netflix.mediaclient
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10