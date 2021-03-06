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
adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.pandora.android/.LauncherActivity
sleep 2

### START ACTIONS HERE

adb shell input tap 985 145
sleep 3

num=$((1 + RANDOM % 3))
if (( $num == 1 )); then
    artist="american"
elif (( $num == 2 )); then
    artist="indian"
else
    artist="korean"
fi


adb shell input text $artist
sleep 3

adb shell input keyevent 111
sleep 2

num1=$((3 + RANDOM % 5))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))

for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
done

adb shell input tap 401 554
sleep 2

adb shell input tap 110 165
sleep 2

num1=$((3 + RANDOM % 5))
num2=$((500 + RANDOM % 1000))
num3=$((1 + RANDOM % 3))

for ((i = 0 ; i < $num1 ; i++));
do
	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
    sleep $num3
    if (( $i % 3 == 0 )); then
        adb shell input tap 401 554
        sleep 2

        adb shell input tap 110 165
        sleep 2
    fi
done
sleep 3
### END ACTIONS HERE

adb -s $PHONE_ID shell am force-stop com.pandora.android
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10