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
adb -s $PHONE_ID shell am start -n com.facebook.orca/com.facebook.orca.auth.StartScreenActivity
sleep 3

adb -s $PHONE_ID shell input tap 300 700 # tapping on coordinates 289x690 on phone

sleep 3
adb -s $PHONE_ID shell input tap 750 1850

sleep 3
array=("testing" "hmm" "bless" "Naeem")

# typing and sending each word on messenger
for element in ${array[@]} 
do
    adb -s $PHONE_ID shell input text $element
    adb -s $PHONE_ID shell input tap 950 1000
done
sleep 2

#back
adb shell input tap 50 100
sleep 5

adb shell am force-stop com.facebook.orca
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}__${TIME}_${PHONE_ID}.pcap"
