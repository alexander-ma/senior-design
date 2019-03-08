import os
import subprocess
from datetime import datetime

import pandas as pd
from scapy.all import *

pwd = os.getcwd()
dir_list = [ name for name in os.listdir(pwd) if os.path.isdir(os.path.join(pwd, name)) ]
location = input('Location of data collection: ')

while True:
    inp = input('Enter directory name: ')
    shortened_dir_list = [name for name in dir_list if name.startswith(inp) or name == inp]
    if inp == 'ls':
        print(dir_list)

    # If there is only one directory starting with that name, go to it
    elif len(shortened_dir_list) == 1:
        app_name = shortened_dir_list[0]
        app_scripts = os.listdir(app_name)
        print("Scripts: " + str(app_scripts))
        inp = input('Enter script name: ')

        # If there is only one script starting with that name, run it
        shortened_script = [name for name in app_scripts if name.startswith(inp) or name == inp]
        if len(shortened_script) == 1:
            script_name = shortened_script[0]
            current_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
            phone_id = input('Enter phone id: ')

            # Runs script as senior-design/reddit/browse.sh -t <time> -s <phone_id>
            script_path = os.path.join('./', app_name, script_name)
            script_cmd = (script_path + ' -t {0} -s {1}'.format(current_time, phone_id)).split()
            subprocess.run(script_cmd) 
        
#        # Remove data payloads to cut down on storage
#        pcap = os.listdir()
#        pcap_file = "{0}_{1}__{2}_{3}.pcap".format(app_name, script_name, current_time, phone_id)
#        packets = rdpcap(pcap_file)
#        for packet in packets:
#            if TCP in packet:
#                packet[TCP].remove_payload()
#            if UDP in packet:
#                packet[UDP].remove_payload()
#        wrpcap(pcap_file, packets)
#        
#        csv_file = filename + '.csv'
#
#        # Convert pcap file to csv
#        subprocess.run('tshark -r ' + pcap_file + ' -T fields -e frame.number -e frame.time -e frame.len -e frame.cap_len -e tcp.hdr_len -e tcp.len -e ip.hdr_len -e ip.len -e udp.length -e ip.src -e ip.dst -e ip.proto -E header=y -E separator=, -E quote=d > ' + csv_file)
#
#        # Add in location row
#        df = pd.read_csv(csv_file)
#        df['location'] = location
#        df.to_csv(csv_file)
