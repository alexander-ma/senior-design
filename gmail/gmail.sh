#!/bin/bash
./adb shell am start -a android.intent.action.VIEW com.google.android.gm/com.google.android.gm.ConversationListActivityGmail
sleep 2

./adb shell input tap 500 1300
sleep 5

./adb shell input tap 50 100
sleep 5

./adb shell input tap 500 1400
sleep 5

back
./adb shell input tap 50 100
sleep 5

email_address="alexander.ma@utexas.edu,%skevinchau@utexas.edu,%schrisraygill@utexas.edu,%sjayajp8@gmail.com"

subject="Meet%sHot%sSingles%sin%sEER!"
body="UTECE%sis%slooking%sfor%shot%ssenior%smales!"

./adb shell input tap 900 1800
sleep 2

./adb shell input text $email_address
sleep 3

./adb shell input tap 500 650
sleep 2

./adb shell input text $subject
sleep 3

./adb shell input tap 500 1050
sleep 2

./adb shell input text $body
sleep 3

# send
./adb shell input tap 900 100
sleep 10

./adb shell am force-stop com.google.android.gm