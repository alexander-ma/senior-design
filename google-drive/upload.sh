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
sleep 2

# Click on plus
adb -s $PHONE_ID shell input tap 935 1795
sleep 2
#Click on Upload
adb -s $PHONE_ID shell input tap 535 1375
sleep 2
#Click on menu
adb -s $PHONE_ID shell input tap 90 171
sleep 2
#Click on Downloads
adb -s $PHONE_ID shell input tap 375 700
sleep 2
#Click on file
adb -s $PHONE_ID shell input tap 545 545
sleep 30

adb -s $PHONE_ID shell am force-stop com.google.android.apps.docs
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
