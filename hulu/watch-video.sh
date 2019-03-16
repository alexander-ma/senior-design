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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.hulu.plus/com.hulu.features.splash.SplashActivity
sleep 2

# DO ACTIONS
for i in {1..5}
do
	sleep 1
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 1000
done
sleep 20

# QUIT APPLICATIONS
adb -s $PHONE_ID shell am force-stop android.intent.action.VIEW com.hulu.plus/com.hulu.features.splash.SplashActivity

# END TCPDUMP
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3

# GENERATING PCAP FILE
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
