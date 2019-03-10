com.netflix.mediaclient/.ui.launch.UIWebViewActivity

#!/bin/bash

echo 'STARTING TCPDUMP...'
adb shell tcpdump -i any -s 0 -w /sdcard/netflix-browse-home.pcap & PID=$!
adb shell am start -a android.intent.action.VIEW com.netflix.mediaclient/.ui.launch.UIWebViewActivity

sleep 10

for i in {1..5}
do
	sleep 1
	adb shell input swipe 500 1500 500 100 1000
done

sleep 10

adb shell am force-stop android.intent.action.VIEW com.netflix.mediaclient/.ui.launch.UIWebViewActivity
echo 'STOPPING TCPDUMP...'
kill ${PID}
sleep 3
echo 'Generating .pcap file...'
adb pull /sdcard/netflix-browse-home.pcap netflix-browse-home.pcap