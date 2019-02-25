#!/bin/bash

echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/netflix-watch-video.pcap & PID=$!
adb shell am start -n com.netflix.mediaclient/.ui.launch.UIWebViewActivity -a android.intent.action.VIEW -d https://www.netflix.com/watch/70176471?trackId=14201532&tctx=10%2C2%2C2ce018ad-a608-4101-9ed8-fe621bce2488-549037375%2C138b0086-ab0c-44f8-b7d2-0b79095a79bd_113130739X28X64256X1551083101958%2C138b0086-ab0c-44f8-b7d2-0b79095a79bd_ROOT
sleep 20
adb shell am force-stop com.netflix.mediaclient
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/spotify.pcap spotify.pcap