#!/bin/bash

adb shell am start -n com.facebook.orca/com.facebook.orca.auth.StartScreenActivity
sleep 5

echo tap first Messenger contact # printing message to console for debugging
adb shell input tap 300 700 # tapping on coordinates 289x690 on phone

sleep 3
echo tap message line
adb shell input tap 750 1850

sleep 3

array=("testing" "hmm" "bless" "Naeem")
echo ${#array[@]}


# typing and sending each word on messenger
for element in ${array[@]} 
do
    echo Send message $element
    adb shell input text $element
    echo tap send
    adb shell input tap 950 1000

done

sleep 5
echo "Finished sending"

#back
adb shell input tap 50 100
sleep 5

adb shell input tap 350 500

sleep 10

adb shell am force-stop com.facebook.orca
