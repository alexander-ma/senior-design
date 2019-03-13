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
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" &
PID=$!
adb -s $PHONE_ID shell am start -n com.netflix.mediaclient/.ui.launch.UIWebViewActivity -a android.intent.action.VIEW -d https://www.netflix.com/watch/70176471?trackId=14201532&tctx=10%2C2%2C2ce018ad-a608-4101-9ed8-fe621bce2488-549037375%2C138b0086-ab0c-44f8-b7d2-0b79095a79bd_113130739X28X64256X1551083101958%2C138b0086-ab0c-44f8-b7d2-0b79095a79bd_ROOT
sleep 20

### START ACTIONS HERE

sleep 10

### END ACTIONS HERE

#adb -s $PHONE_ID shell am force-stop android.intent.action.VIEW com.netflix.mediaclient
adb -s $PHONE_ID shell am force-stop com.netflix.mediaclient
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
