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
adb shell am start -a android.intent.action.VIEW com.google.android.talk/.SigningInActivity
sleep 2

#tap new conversation
adb shell input tap 900 1800
sleep 2
adb shell input tap 900 1800
sleep 2

email_address="boomjosh12345@gmail.com"

adb shell input text $email_address
sleep 3

# tap
adb shell input tap 515 815
sleep 3


# call
adb shell input tap 880 186
sleep 10

adb shell input tap 540 1741
sleep 20

adb -s $PHONE_ID shell am force-stop com.google.android.talk
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10