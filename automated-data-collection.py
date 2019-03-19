import os
import subprocess
from datetime import datetime
import pandas as pd
from scapy.all import *
from concurrent.futures import ThreadPoolExecutor
import threading
import random


def pick_random_script():
	global bob
	#Production code. Comment out not working scripts code below when testing
	# if bob == -1:
	# 	#Comment this out when testing
	# 	not_working_scripts = ["hulu/scroll-home.sh", "hulu/watch-video.sh", "snapchat/add-friend.sh", "spotify/download-music", "spotify/play-music", "spotify/search-music"]
	# 	for script in not_working_scripts:
	# 		all_scripts.remove(script)
	# 	bob = bob + 1

	return random.choice(all_scripts)

	##For testing all the scripts
	
	# return all_scripts[bob]

	##For testing an individual script
	# return "gmail/send-email.sh"

def get_pcap_filename(filename):
	return 'pcap/' + filename + '.pcap'

def get_csv_filename(filename):
	return 'csv/' + filename + '.csv'

def get_filename(app_name, script_name, current_time, phone_id):
	return "{0}_{1}_{2}_{3}".format(app_name, script_name[:-3], current_time, phone_id)

def remove_data_payloads(filename):
	print("Removing Payloads", flush=True)
	pcap_file = get_pcap_filename(filename)
	print(pcap_file, flush=True)
	packets = rdpcap(pcap_file)
	for packet in packets:
	    if TCP in packet:
	        packet[TCP].remove_payload()
	    if UDP in packet:
	        packet[UDP].remove_payload()
	wrpcap(pcap_file, packets)
	return filename

def pcap_to_csv(filename):
	pcap_file = get_pcap_filename(filename)
	csv_file = get_csv_filename(filename)

	print('Converting to csv...', flush=True)
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
	print('Conversion completed', flush=True)

	# Add in location row
	df = pd.read_csv(csv_file)
	df['location'] = location
	df.to_csv(csv_file)
	os.remove(pcap_file) 

def task(phone_id, script_path, script_num):
	print("[", phone_id, "] [", script_path, "] Script start iteration: ", script_num, flush=True)
	current_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
	exec_script_path = os.path.join('./', script_path)
	script_cmd = (exec_script_path + ' -t {0} -s {1}'.format(current_time, phone_id)).split()
	subprocess.run(script_cmd)
	app_info = script_path.split('/') # example: reddit/browse.sh -> [reddit, browse.sh]
	filename = get_filename(app_info[0], app_info[1], current_time, phone_id)
	print(filename, flush=True)
	remove_data_payloads(filename)
	pcap_to_csv(filename)
	print("[", phone_id, "] [", script_path, "] Script end iteration: ", script_num, flush=True)
	

bob = -1

pwd = os.getcwd()
dir_list = [ name for name in os.listdir(pwd) if os.path.isdir(os.path.join(pwd, name)) ]

location = input('Location of data collection: ')
num_scripts = input('How many random application actions do you want to collect data on?: ')

#Get list of all runnable scripts
all_scripts = []
for directory in dir_list:
	files = os.listdir(directory)
	for file in files:
		if (file.endswith(".sh")):
			all_scripts.append(directory + "/" + file)
print("All scripts len: ", len(all_scripts))

#Execute different scripts concurrently on each phone
exec1 = ThreadPoolExecutor(max_workers=1)
exec2 = ThreadPoolExecutor(max_workers=1)
exec3 = ThreadPoolExecutor(max_workers=1)
executors = [exec1, exec2, exec3]

list_devices_cmd = 'adb devices'.split()
byte_device_output = subprocess.run(list_devices_cmd, stdout = subprocess.PIPE)
string_device_output = byte_device_output.stdout.decode("utf-8");
string_device_output = string_device_output.split();
device_list = []
for x in range(4, len(string_device_output), 2):
    device_list.append(string_device_output[x])

not_working_scripts = ["hulu/scroll-home.sh", "hulu/watch-video.sh", "snapchat/add-friend.sh", "spotify/download-playlist.sh", "spotify/play-music.sh", "spotify/search-music.sh", "twitter/post-tweet.sh", "twitter/scroll-feed.sh", "hangout/hangout.sh"]
for script in not_working_scripts:
	all_scripts.remove(script)

num_devices = len(device_list)
print("device list num: ", num_devices)
for num in range(int(num_scripts)):
	cur_device = num % num_devices

	if num % num_devices == 0:
		bob = bob + 1
	script_path = pick_random_script()
	executors[cur_device].submit(task, (device_list[cur_device]), (script_path), num)