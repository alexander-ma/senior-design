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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.google.android.apps.docs/com.google.android.apps.docs.doclist.activity.DocListActivity
sleep 4

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    filename="VID_20190308_151916.mp4"
elif (( $num == 2 )); then
    filename="VID_20190331_132024.mp4"
else
    filename="VID_20190331_131947.jpg"
fi

# Tap on search
adb -s $PHONE_ID shell input tap 770 180
adb -s $PHONE_ID shell input tap 770 180
sleep 2
#Enter filename
adb -s $PHONE_ID shell input text $filename
adb -s $PHONE_ID shell input keyevent 66
sleep 10

# Tap on options
adb -s $PHONE_ID shell input tap 485 875
sleep 2
# Swipe up on more options
adb -s $PHONE_ID shell input swipe 600 1300 600 600 200
adb -s $PHONE_ID shell input swipe 600 1300 600 600 200
sleep 2
#Download file
adb -s $PHONE_ID shell input tap  600 870
sleep 20

adb -s $PHONE_ID shell am force-stop com.google.android.apps.docs
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10