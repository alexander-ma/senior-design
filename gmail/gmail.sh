#!/bin/bash
adb shell am start -a android.intent.action.VIEW com.google.android.gm/com.google.android.gm.ConversationListActivityGmail
sleep 2

adb shell input tap 500 1300
sleep 3

adb shell input tap 50 100
sleep 3

adb shell input tap 500 1500
sleep 3

#back
adb shell input tap 50 100
sleep 3

email_address="utece.5gml@gmail.com"

subject="Meet%sHot%sSingles%sin%sEER!"
body="UTECE%sis%slooking%sfor%shot%ssenior%smales!"

adb shell input tap 900 1800
sleep 2

adb shell input text $email_address
sleep 3

adb shell input tap 500 700
sleep 2

adb shell input tap 500 675
sleep 2

adb shell input text $subject
sleep 3

adb shell input tap 500 870
sleep 2

adb shell input text $body
sleep 3

# send
adb shell input tap 900 100
sleep 10

adb shell am force-stop com.google.android.gm