# senior-design
UT Austin Senior Design Project

## Data Collection
### Prerequisites
Have the following installed:
- adb
  - symlink where it's downloaded to the senior-design directory
  - `ln -s /where/is/adb /where/is/senior-design`
- tcpdump
- Dropbox and Google Drive scripts require that a file be present in the downloads folder of the phone
- All phones must have the apps downloaded and login information entered
- These scripts cannot run when mulitple phones are connected: "hulu/scroll-home.sh", "hulu/watch-video.sh", "spotify/download-playlist.sh", "spotify/play-music.sh", "spotify/search-music.sh", "twitter/post-tweet.sh", "twitter/scroll-feed.sh", "hangout/hangout.sh"

### Automated Collection Process
1. Connect phones to the computer
2. Run automated-data-collection.py
    - Choose the location you are collection this data at (Example: EER, Houston, etc)
    - Select the number of scripts you want the script to randomly choose to run from the available scripts in the directories inside the senior-design repository
3. All the pcaps will be deleted and the converted csvs will be in the csv folder.
4. Upload all csvs to Google Drive and delete local copy to save local storage space
5. FAQ
  - Running Scripts
    - If you want to run a single script: Uncomment the single script line of code in the pick_random_script function
    - If you want to run scripts on multiple phones simultaneously: uncomment return random.choice(all_scripts) in the pick_random_script function
    - If you want to run the scripts which only run on a single phone: uncomment "Running scripts which run on one phone only" section in the pick_random_script function
  - How does the auto reboot work and why is it required?
    - Auto reboot, reboots the phones after a certain number of scripts are run on each phone. This number is defined in the variable reboot_after_num_scripts in automated-data-collection.py
    - This is required because there is an issue with LineageOS where the deleted files are temporarily stored and are only deleted completely after a full reboot.
  - How does the multi-threading work?
    - Each phone has it's own executor service with a single thread so that we can concurrently run different scripts on each phone. This is because we did not want any race conditions between the execution of scripts. For example if we only have one executor service with two threads running, and the next two items on the thread queue are tasks for phone 1, then each thread will try to simulultaneously run a different script on phone 1 and one script will collide in execution with the other script in the different thread. So having one queue of tasks for each executor service will ensure that each phone will execute a script only after the previous script has finished execution.

### Collection Process
1. Connect the phone and run: `adb root`
2. Start the application and to find package/activity name:
    - Run the following line: `adb shell dumpsys window windows | grep -E 'mCurrentFocus'`
    - http://www.automationtestinghub.com/apppackage-and-appactivity-name/
3. To get coordinates on top of the screen, go to Settings > System > Developer options > Pointer location

### Scripting Process
1. Start header with #!/bin/bash (may change to Python in the future)
2. To start the application, run: `adb shell am start replace.with.activity`
3. [Optional] Add in some amount of sleep to allow application to start
6. Use `echo` as print statements to describe what is going on and for debugging
4. Use `adb shell input tap X Y` to tap in the corresponding screen coordinates (replace **X** and **Y**)
5. Use `adb shell input text placeholder` to input words (replace **placeholder**)

### Scripting Process (ALTERNATE)
- Follow instructions here: https://github.com/Cartucho/android-touch-record-replay

### Running ADB Scripts on Multiple Devices
To check which devices are connected to a computer, run `adb devices` to get a list of devices attached with their device ID.

To run an ADB command with a certain device, use the `-s` flag along with the device ID.

`adb -s d56097ed shell am start -a android.intent.action.VIEW ..."`

### Convert .pcap to .csv files
1. Install tshark: `sudo apt-get install tshark`
2. Use the following command: `tshark -r input.pcap -T fields -e frame.number -e frame.time -e frame.len -e frame.cap_len -e tcp.hdr_len -e tcp.len -e ip.hdr_len -e ip.len -e udp.length -e ip.src -e ip.dst -e ip.proto -E header=y -E separator=, -E quote=d > output.csv`
    - `-r input.cap` specifies which file to read from
    - `-T fields` sets the format of the output 
    - `-e <field>` adds a field to list of fields to display from `-T fields`
    - `-E <field print option>` specifies how to print the fields
    - For more information: https://www.wireshark.org/docs/man-pages/tshark.html
