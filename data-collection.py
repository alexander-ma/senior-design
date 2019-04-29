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
            list_devices_cmd = 'adb devices'.split()
            subprocess.run(list_devices_cmd)
            phone_id = input('Enter phone id: ')

            # Runs script as senior-design/reddit/browse.sh -t <time> -s <phone_id>
            script_path = os.path.join('./', app_name, script_name)
            script_cmd = (script_path + ' -t {0} -s {1}'.format(current_time, phone_id)).split()
            subprocess.run(script_cmd) 
        
        # Remove data payloads to cut down on storage
        filename = "{0}_{1}_{2}_{3}".format(app_name, script_name[:-3], current_time, phone_id)
        pcap_file = 'pcap/' + filename + '.pcap'
        csv_file = 'csv/' + filename + '.csv'

        packets = rdpcap(pcap_file)
        for packet in packets:
            if TCP in packet:
                packet[TCP].remove_payload()
            if UDP in packet:
                packet[UDP].remove_payload()
        wrpcap(pcap_file, packets)
        

        # Convert pcap file to csv
        print('Converting to csv...')
        pcap_to_csv_cmd = ('tshark -r ' + pcap_file + ' -T fields '
                + '-e frame.number '
                + '-e frame.time '
                + '-e frame.len '
                + '-e frame.cap_len '
                + '-e sll.pkttype '
                + '-e sll.hatype '
                + '-e sll.halen '
                + '-e sll.src.eth '
                + '-e sll.unused '
                + '-e sll.etype '
                + '-e ip.hdr_len '
                + '-e ip.dsfield.ecn '
                + '-e ip.len '
                + '-e ip.id '
                + '-e ip.frag_offset '
                + '-e ip.ttl '
                + '-e ip.proto '
                + '-e ip.checksum '
                + '-e ip.src '
                + '-e ip.dst '
                + '-e tcp.hdr_len '
                + '-e tcp.len '
                + '-e tcp.srcport '
                + '-e tcp.dstport '
                + '-e tcp.seq '
                + '-e tcp.ack '
                + '-e tcp.flags.ns '
                + '-e tcp.flags.fin '
                + '-e tcp.window_size_value '
                + '-e tcp.checksum '
                + '-e tcp.urgent_pointer '
                + '-e tcp.option_kind '
                + '-e tcp.option_len '
                + '-e tcp.options.timestamp.tsval '
                + '-e tcp.options.timestamp.tsecr '
                + '-e udp.srcport '
                + '-e udp.dstport '
                + '-e udp.length '
                + '-e udp.checksum '
                + '-e gquic.puflags.rsv '
                + '-e gquic.packet_number '
                + '-E header=y -E separator=, -E quote=d > ' + csv_file)
        subprocess.run(pcap_to_csv_cmd, shell=True)
        print('Conversion completed')

        # Add in location row
        df = pd.read_csv(csv_file)
        df['location'] = location
        df.to_csv(csv_file)

