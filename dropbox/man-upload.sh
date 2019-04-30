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

adb -s $PHONE_ID shell am start -a android.intent.action.VIEW com.dropbox.android/com.dropbox.android.activity.DbxMainActivity
sleep 5

### ----------- START ACTIONS HERE --------------

## ------- START RECORDING --------
echo 'STARTING TCPDUMP...'
adb -s $PHONE_ID shell tcpdump -i any -s 0 -w "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" &
PID=$!

# Manual navigation
sleep 150

### ----------- END ACTIONS HERE ----------------

adb -s $PHONE_ID shell am force-stop com.dropbox.android
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb -s $PHONE_ID pull "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" "pcap/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap" 
adb -s $PHONE_ID shell rm "/sdcard/${dir_name}_${script_name}_${TIME}_${PHONE_ID}.pcap"
sleep 10

### ------------ COMMAND LIST -------------

## Basics

# General Swipe: adb -s $PHONE_ID shell input swipe <x1> <y1> <x2> <y2>
# Swipe Up: adb -s $PHONE_ID shell input swipe 550 1650 550 550
# Swipe Down: adb -s $PHONE_ID shell input swipe 550 550 550 1650
# Swipe Left: adb -s $PHONE_ID shell input swipe 1000 1000 100 1000
# Swipe Right: adb -s $PHONE_ID shell input swipe 100 1000 1000 1000
# Tap/Click: adb -s $PHONE_ID shell input tap <x> <y>
# Input Text: adb -s $PHONE_ID shell input text <text>
# Hit Enter on Text: adb -s $PHONE_ID shell input keyevent 66

## Select randomly from several actions (text, clicks, etc...)

# num=$((RANDOM % <num_choices>))
# if (( $num == 0 )); then
#     <action 1>
# elif (( $num == 1)); then
#     <action 2>
# else
#     <action 3>
# fi
# sleep 2

## Randomize Scrolls

# num1=$((<min> + RANDOM % <range>))
# num2=$((<min> + RANDOM % <range>))
# echo $num1
# for ((i = 0 ; i < $num1 ; i++));
# do
# 	adb -s $PHONE_ID shell input swipe <x1> <y1> <x2> <y2>
#   sleep $num2
# done
# sleep 2
