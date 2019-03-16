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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.dropbox.android/com.dropbox.android.activity.DbxMainActivity
sleep 5

# Tap on file ...
adb -s $PHONE_ID shell input tap 1000 1075
sleep 2
# Swipe up on more options
adb -s $PHONE_ID shell input swipe 600 1300 600 600 200
adb -s $PHONE_ID shell input swipe 600 1300 600 600 200
sleep 2
# Tap on Export
adb -s $PHONE_ID shell input tap 590 1423
sleep 2
# Tap on Save to device
adb -s $PHONE_ID shell input tap 550 330
sleep 2
# Tap on Save
adb -s $PHONE_ID shell input tap 1000 1830

sleep 10
adb -s $PHONE_ID shell am force-stop com.dropbox.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10