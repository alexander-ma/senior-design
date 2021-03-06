import os
import subprocess

pcap_file = './pcap/google-drive_manual_2019-03-31_12-23-47_d56097ed.pcap'
csv_file = './csv/google-drive_manual_2019-03-31_12-23-47_d56097ed.csv'

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