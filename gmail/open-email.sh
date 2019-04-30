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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.google.android.gm/com.google.android.gm.ConversationListActivityGmail
sleep 5

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    num1="1300"
elif (( $num == 2 )); then
    num1="1500"
else
    num1="940"
fi

num1="940"
adb -s $PHONE_ID shell input tap 500 $num1
sleep 3

#back
adb -s $PHONE_ID shell input tap 50 100
sleep 3

num1=$((5 + RANDOM % 10))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))
echo $num1
for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
    adb -s $PHONE_ID shell input tap 603 1296
    sleep 2
    adb -s $PHONE_ID shell input tap 50 100
done
sleep 3

adb -s $PHONE_ID shell am force-stop com.google.android.gm
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10