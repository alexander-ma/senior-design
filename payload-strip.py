from scapy.all import *
INFILE = 'youtube.pcap'
OUTFILE = 'stripped.pcap'
paks = rdpcap(INFILE)
for pak in paks:
    if TCP in pak:
        pak[TCP].remove_payload()
    if UDP in pak:
        pak[UDP].remove_payload()
wrpcap(OUTFILE, paks)
