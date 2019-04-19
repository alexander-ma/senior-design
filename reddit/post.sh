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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.reddit.frontpage/com.reddit.frontpage.MainActivity
sleep 2

# Create text post
adb -s $PHONE_ID shell input tap 550 1850
sleep 2
adb -s $PHONE_ID shell input tap 900 1650
sleep 2
adb -s $PHONE_ID shell input tap 550 340
sleep 2
# Choose community
adb -s $PHONE_ID shell input tap 550 550
sleep 2
adb -s $PHONE_ID shell input tap 550 500
sleep 2

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    postTerm="Testing"
elif (( $num == 2 )); then
    postTerm="Bob%sTesting"
else
    postTerm="Jill%sTesting"
fi

adb -s $PHONE_ID shell input text $postTerm
sleep 2
adb -s $PHONE_ID shell input tap 550 650
sleep 2

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    detailText="ignore"
elif (( $num == 2 )); then
    detailText="more%snecessary"
else
    detailText="not%sreally%ssure"
fi

adb -s $PHONE_ID shell input text $detailText
sleep 2
adb -s $PHONE_ID shell input tap 970 190

sleep 20

adb -s $PHONE_ID shell am force-stop com.reddit.frontpage
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10