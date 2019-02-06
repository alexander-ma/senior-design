#!/bin/bash
# Start tcpdump and stores pcap onto sdcard of phone
./adb shell tcpdump -i any -s 0 -w /sdcard/youtube.pcap &

PID=$!
./youtube/play-video.sh
kill ${PID}
sleep 3

# Pulls from the phone to the computer 
./adb pull /sdcard/youtube.pcap youtube.pcap

# Repeated as above, but with Spotify playing music
./adb shell tcpdump -i any -s 0 -w /sdcard/spotify.pcap &

PID=$!
./spotify/play-music.sh
kill ${PID}
sleep 3

./adb pull /sdcard/spotify.pcap spotify.pcap


# Remove all pcap files from SD card so that we can make room
./adb shell rm -r sdcard/*.pcap