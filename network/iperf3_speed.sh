#!/bin/bash

# Function to check if a command is available
check_command() {
    command -v "$1" > /dev/null 2>&1
}

# Function to install a package if not available
install_package() {
    if ! check_command "$1"; then
        echo "Command ${1} not found. Installing..."
        echo "Please enter your sudo password if prompted."
        sudo apt-get install -y "${1}"  # Adjust for your package manager
    fi
}

# Check and install nmap and iperf3
install_package "nmap"
install_package "iperf3"

# Get base IP and scan for the device with the specified MAC address
base_ip=$(ip route | grep default | awk '{print $3}' | cut -d. -f1-3)
target_mac="DC:A6:32:B6:B3:5A"

echo "Scanning for device with MAC address ${target_mac} on network ${base_ip}.0/24..."

result=$(sudo nmap -sP "${base_ip}.0/24" | grep -B 2 "${target_mac}")

device_ip=$(echo "${result}" | awk '/Nmap scan report/{print $5}')

if [ -z "${device_ip}" ]; then
    echo "Device with MAC address ${target_mac} not found on the network."
    exit 1
fi

echo "Device found at IP: ${device_ip}"

# Launch iperf3 command
iperf3 -p 5201 -c "${device_ip}" -f m
