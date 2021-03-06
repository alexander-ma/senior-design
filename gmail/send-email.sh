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
sleep 4

num1=$((2 + RANDOM % 3))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))

for i in range {$num3}
do
    num=$((1 + RANDOM % 2))
    if (( $num == 1 )); then
        email_address="utece.5gml@gmail.com"
        subject="Testing%sGmail%sEmail!"
        body="Testing%sthe%sbody%sof%sthe%sgmail%smessage!"
    else
        email_address="boomjosh12345@gmail.com"
        body="Testing%sGmail%sEmail!"
        subject="Testing%sthe%sbody%sof%sthe%sgmail%smessage!"
    fi

    adb -s $PHONE_ID shell input tap 900 1800
    sleep 2

    adb -s $PHONE_ID shell input text $email_address
    sleep 3

    adb -s $PHONE_ID shell input tap 500 700
    sleep 2

    adb -s $PHONE_ID shell input tap 500 675
    sleep 2

    adb -s $PHONE_ID shell input text $subject
    sleep 3

    adb -s $PHONE_ID shell input tap 500 870
    sleep 2

    num4=$((3 + RANDOM % 5))
    num5=$((500 + RANDOM % 1000))
    num6=$((1 + RANDOM % 3))
    echo $num4
    for ((i = 0 ; i < $num4 ; i++));
    do
        adb -s $PHONE_ID shell input text $body
        sleep $num6 
    done
    sleep 3

    # send
    adb -s $PHONE_ID shell input tap 900 100
    sleep 10
done

sleep 3

adb -s $PHONE_ID shell am force-stop com.google.android.gm
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10