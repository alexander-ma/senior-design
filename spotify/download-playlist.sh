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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.spotify.music/.MainActivity
sleep 5

echo 'CLICKING SEARCH BUTTON'
adb shell input tap 491 1845
sleep 2

echo 'CLICKING SEARCH BAR'
adb shell input tap 534 635
sleep 2

query="playlist"

echo 'INPUTING QUERY'
adb shell input text $query
sleep 2

echo 'CLICKING SONG SIDEBAR OPTIONS'
adb shell input tap 980 340
sleep 2

echo 'CLICK DOWNLOAD PLAYLIST'
adb shell input tap 595 1423
echo 'DOWNLOADING PLAYLIST'
sleep 30

echo 'CLICKING SONG SIDEBAR OPTIONS'
adb shell input tap 980 340
sleep 2

echo 'CLICK REMOVE DOWNLOAD'
adb shell input tap 500 1423

sleep 2

adb -s $PHONE_ID shell am force-stop com.spotify.music
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10