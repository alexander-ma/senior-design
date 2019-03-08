# senior-design
UT Austin Senior Design Project

## Data Collection
### Prerequisites
Have the following installed:
- adb
  - symlink where it's downloaded to the senior-design directory
  - `ln -s /where/is/adb /where/is/senior-design`
- tcpdump

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
