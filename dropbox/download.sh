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

# Start tcpdump
echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" &
PID=$!
sleep 3
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.dropbox.android/com.dropbox.android.activity.DbxMainActivity
sleep 5

num=$((1 + RANDOM % 3))

if (( $num == 1 )); then
    file1="181206"
elif (( $num == 2)); then
    file1="224841"
else
    file1="151916"
fi

# Tap on file ...
echo $file1
adb -s $PHONE_ID shell input tap 725 179
sleep 1
adb -s $PHONE_ID shell input text $file1
adb -s $PHONE_ID shell input keyevent 66
sleep 1
adb -s $PHONE_ID shell input tap 1000 485
# Swipe up on more options
for i in {1..2}
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
done
sleep 2
# Tap on Export
adb -s $PHONE_ID shell input tap 590 1423
sleep 2
# Tap on Save to device
adb -s $PHONE_ID shell input tap 550 330
sleep 2

# Tap on Save
adb -s $PHONE_ID shell input tap 1000 1830

sleep 20
adb -s $PHONE_ID shell am force-stop com.dropbox.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10