#!/bin/bash
./adb shell am start -a android.intent.action.VIEW "https://open.spotify.com/track/3kZC0ZmFWrEHdUCmUqlvgZ\?si\=_ZeVzH0XSL-HkJ33HNUDfw"
sleep 20
./adb shell am force-stop com.spotify.music