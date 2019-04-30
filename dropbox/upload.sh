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

# Tap on + button
adb -s $PHONE_ID shell input tap 940 1790
sleep 2
# Tap on Upload photos or videos
adb -s $PHONE_ID shell input tap 540 1035
sleep 2
# Tap on photo or video to upload
num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    adb -s $PHONE_ID shell input tap 904 1128
elif (( $num == 2)); then
    adb -s $PHONE_ID shell input tap 236 1136
else
    adb -s $PHONE_ID shell input tap 228 1589
fi
sleep 2

# Tap on Upload
adb -s $PHONE_ID shell input tap 923 1789
sleep 2
# Tap on Replace existing file
adb -s $PHONE_ID shell input tap 829 1154

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