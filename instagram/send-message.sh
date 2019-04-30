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

adb -s $PHONE_ID shell am start -n com.instagram.android/com.instagram.android.activity.MainTabActivity
sleep 2

# ------------- START ACTIVITY ---------------

# Click message arrow
adb -s $PHONE_ID shell input tap 1012 144
sleep 1

# ------- START RECORDING ---------
echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" &
PID=$!
sleep 2

# Click most recent convo
adb -s $PHONE_ID shell input tap 542 546
sleep 1

# Click most recent convo
adb -s $PHONE_ID shell input tap 439 1808
sleep 1

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
sleep 2

# ------------- END ACTIVITY ------------------

sleep 3
adb -s $PHONE_ID shell am force-stop com.instagram.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
sleep 1
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
sleep 3
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10


# ------- COMMAND LIST --------

# Swipe Up: adb -s $PHONE_ID shell input swipe 550 1650 550 550
# Swipe Down: adb -s $PHONE_ID shell input swipe 550 550 550 1650
# Swipe Left: adb -s $PHONE_ID shell input swipe 1000 1000 100 1000
# Swipe Right: adb -s $PHONE_ID shell input swipe 100 1000 1000 1000
# Tap/Click: adb -s $PHONE_ID shell input tap <x> <y>
# Input Text: adb -s $PHONE_ID shell input text <text>
# Hit Enter on Text: 

# Randomize Click/ Selection

# num=$((RANDOM % <num_choices>))
# if (( $num == 0 )); then
#     adb -s $PHONE_ID shell input tap <x> <y>
# elif (( $num == 1)); then
#     adb -s $PHONE_ID shell input tap <x> <y>
# else
#     adb -s $PHONE_ID shell input tap <x> <y>
# fi
# sleep 2

# Randomize Scrolls

# num1=$((<min> + RANDOM % <max>)) #avg 3
# num2=$((<min> + RANDOM % <max>)) #avg 3
# echo $num1
# for ((i = 0 ; i < $num1 ; i++));
# do
# 	adb -s $PHONE_ID shell input swipe 500 1500 500 100 $num2
#     sleep $num3
# done
# sleep 2

# Randomize Text

# num=$((RANDOM % <num_choices>))
# if (( $num == 0 )); then
#     text="word1"
# elif (( $num == 1 )); then
#     text="word2"
# else
#     text="word3"
# fi