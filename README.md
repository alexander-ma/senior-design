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
3. To get coordinates run: `adb shell getevent -l | grep "ABS_MT_POSITION"`
4. Record the ABS_MT_POSITION for X and Y as these are the screen coordinates
5. Convert the X and Y from hex to decimal

### Scripting Process (NEW)
- Follow instructions here: https://github.com/Cartucho/android-touch-record-replay

### Scripting Process (OLD)
1. Start header with #!/bin/bash (may change to Python in the future)
2. To start the application, run: `adb shell am start replace.with.activity`
3. [Optional] Add in some amount of sleep to allow application to start
6. Use `echo` as print statements to describe what is going on and for debugging
4. Use `adb shell input tap X Y` to tap in the corresponding screen coordinates (replace **X** and **Y**)
5. Use `adb shell input text placeholder` to input words (replace **placeholder**)
