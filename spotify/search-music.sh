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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.spotify.music/com.spotify.music.MainActivity
sleep 2

### START ACTIONS HERE

adb shell input tap 491 1845
sleep 3

adb shell input tap 534 635
sleep 3

artist="american"

adb shell input text $artist
sleep 3

adb shell input keyevent 111
sleep 2

for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 500
done

adb shell input tap 401 554
sleep 3

for i in {1..5}
do
	adb shell input swipe 500 1500 500 100 1000
	sleep 1
done

### END ACTIONS HERE

adb -s $PHONE_ID shell am force-stop com.spotify.music
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10