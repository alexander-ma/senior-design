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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.snapchat.android/com.snapchat.android.LandingPageActivity
sleep 2

declare -a array=("user1" "user2" "user3")
for element in ${array[@]}
do
    sleep 1
    adb shell input tap 266 133
    echo Add friend $element
    sleep 1
    adb shell input text $element
    sleep 1
    echo tap add
    adb shell input tap 859 358
    sleep 1
    echo tap clear
    adb shell input tap 1006 123

done

adb -s $PHONE_ID shell am force-stop com.snapchat.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
