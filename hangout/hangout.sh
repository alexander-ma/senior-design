#!/bin/bash
adb shell am start -a android.intent.action.VIEW com.google.android.talk/.activity.BabelProfileActionActivity
sleep 2

#tap new conversation
adb shell input tap 900 1800
sleep 2

email_address="utece.5gml@gmail.com"

adb shell input text $email_address
sleep 3

# tap
adb shell input tap 500 400
sleep 3

# call
adb shell input tap 600 200
sleep 3