#!/bin/bash

# START TCPDUMP
echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/netflix-watch-video.pcap & PID=$!

# START APPLICATION BY LINK
adb shell am start -a android.intent.action.VIEW com.hulu.plus/com.hulu.features.splash.SplashActivity
sleep 20
adb shell am force-stop com.hulu.plus

# END TCPDUMP
echo 'STOPPING TCPDUMP...'
kill ${PID}

# GENERATING PCAP FILE
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/hulu.pcap hulu.pcap