#!/bin/bash
./adb shell am start -a android.intent.action.VIEW "http://www.youtube.com/watch?v=4EGc3r3qni8"
sleep 10
./adb shell am force-stop com.google.android.youtube