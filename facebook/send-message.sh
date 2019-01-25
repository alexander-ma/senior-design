#!/bin/bash

../platform-tools/adb.exe shell am start -n com.facebook.orca/com.facebook.orca.auth.StartScreenActivity
sleep 2

echo tap first Messenger contact # printing message to console for debugging
../platform-tools/adb.exe shell input tap 289 690 # tapping on coordinates 289x690 on phone

echo tap message line
../platform-tools/adb.exe shell input tap 556 1748

array=("testing" "hmm" "bless" "Naeem")
echo ${#array[@]}

# typing and sending each word on messenger
for element in ${array[@]} 
do
    echo Send message $element
    ../platform-tools/adb.exe shell input text $element
    echo tap send
    ../platform-tools/adb.exe shell input tap 1004 962

done

echo "Finished"
