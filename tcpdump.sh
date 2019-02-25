#!/bin/bash
# Start tcpdump and stores pcap onto sdcard of phone
./adb shell tcpdump -i any -s 0 -w /sdcard/youtube.pcap &

PID=$!
./youtube/play-video.sh
kill ${PID}
sleep 3

# Pulls from the phone to the computer 
./adb pull /sdcard/youtube.pcap youtube.pcap

./adb shell tcpdump -i any -s 0 -w /sdcard/youtube.pcap &

PID=$!
./youtube/catSearch.sh
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

# Repeated as above, but with Spotify playing music
./adb shell tcpdump -i any -s 0 -w /sdcard/spotify.pcap &

PID=$!
./spotify/search-music.sh
kill ${PID}
sleep 3

./adb pull /sdcard/spotify.pcap spotify.pcap

# Repeated as above, but with Facebook
./adb shell tcpdump -i any -s 0 -w /sdcard/facebook.pcap &

PID=$!
./facebook/fb.sh
kill ${PID}
sleep 3

./adb pull /sdcard/facebook.pcap facebook.pcap

# Repeated as above, but with Facebook
./adb shell tcpdump -i any -s 0 -w /sdcard/messenger.pcap &

PID=$!
./messenger/send-message.sh
kill ${PID}
sleep 3

./adb pull /sdcard/messenger.pcap messenger.pcap

# Repeated as above, but with gmail
./adb shell tcpdump -i any -s 0 -w /sdcard/gmail.pcap &

PID=$!
./gmail/gmail.sh
kill ${PID}
sleep 3

./adb pull /sdcard/gmail.pcap gmail.pcap

# Repeated as above, but with instagram
./adb shell tcpdump -i any -s 0 -w /sdcard/instagram.pcap &

PID=$!
./instagram/IgSearchBrowse.sh
kill ${PID}
sleep 3

./adb pull /sdcard/instagram.pcap instagram.pcap

# Repeated as above, but with gmail
./adb shell tcpdump -i any -s 0 -w /sdcard/twitter.pcap &

PID=$!
./twitter/post-tweet.sh
kill ${PID}
sleep 3

./adb pull /sdcard/twitter.pcap twitter.pcap

# Repeated as above, but with gmail
./adb shell tcpdump -i any -s 0 -w /sdcard/twitter.pcap &

PID=$!
./twitter/scroll-feed.sh
kill ${PID}
sleep 3

./adb pull /sdcard/twitter.pcap twitter.pcap

# Remove all pcap files from SD card so that we can make room
# ./adb shell rm -r sdcard/*.pcap