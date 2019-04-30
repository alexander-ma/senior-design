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

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    link="https://open.spotify.com/track/3kZC0ZmFWrEHdUCmUqlvgZ\?si\=_ZeVzH0XSL-HkJ33HNUDfw"
elif (( $num == 2 )); then
    link="https://open.spotify.com/track/0MckhqoLpJ5alrdGvujQq8"
else
    link="https://open.spotify.com/track/7Lgmrd7iMgqctENiGTzAfe"
fi

adb -s $PHONE_ID shell am start -a android.intent.action.VIEW $link

### START ACTIONS HERE

sleep 30

### END ACTIONS HERE

adb -s $PHONE_ID shell am force-stop com.spotify.music
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10