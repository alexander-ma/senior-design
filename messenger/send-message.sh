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

adb -s $PHONE_ID shell am start -n com.facebook.orca/com.facebook.orca.auth.StartScreenActivity
sleep 5

# ------------- START ACTIVITY ---------------

# Tap on search bar
adb -s $PHONE_ID shell input tap 533 430
sleep 2

# Enter Text
name="UT"
adb -s $PHONE_ID shell input text $name
adb -s $PHONE_ID shell input keyevent 66
sleep 2

# ------- START RECORIDNG -------
echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" &
PID=$!
sleep 2

#Tap on user
adb -s $PHONE_ID shell input tap 500 500
sleep 2

#Tap on the message bar
adb -s $PHONE_ID shell input tap 683 1843

# Randomize number of messages

num1=$((3 + RANDOM % 4)) # 3-6
num2=$((1 + RANDOM % 2)) # 1-2
for ((i = 0 ; i < $num1 ; i++));
do
	#Randomize Text
    num3=$((RANDOM % 3)) # 0-2
    if (( $num3 == 0 )); then
        text="Hi%sChris,%shows%sit%sgoing%samigo!"
    elif (( $num3 == 1 )); then
        text="This%sis%sjust%sword%svomit,%sgotta%shit%sthat%sword%scount!"
    else
        text="The%smost%spowerful%savenger!"
    fi
    sleep 1
    adb -s $PHONE_ID shell input text $text
    adb -s $PHONE_ID shell input keyevent 66
    sleep $num2
done

# ------------- END ACTIVITY ---------------

sleep 3
adb -s $PHONE_ID shell am force-stop com.facebook.orca
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10