#!/bin/bash

while getopts t:s: option; do
    case $option in
        t) TIME=$OPTARG;;
        s) PHONE_ID=$OPTARG;;
    esac
done

script_name=`basename "$0"`
script_name=${script_name::-3}
dir_name=`dirname "$0"`
dir_name=${dir_name:2}

echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}__${TIME}_${SERIAL_ID}.pcap" &
PID=$!
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW "https://open.spotify.com/track/3kZC0ZmFWrEHdUCmUqlvgZ\?si\=_ZeVzH0XSL-HkJ33HNUDfw"
sleep 2

### START ACTIONS HERE

sleep 10

### END ACTIONS HERE

adb -s $PHONE_ID shell am force-stop <REPLACE.ACTIVITY.HERE>
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
