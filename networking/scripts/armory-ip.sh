#!/bin/bash
#
# Usage: # ./armory-ip <interface>
#
# One-stop networking configuration script for the USBArmory.
# Brings up <interface>, assigns it the IP address 10.0.0.2/24,
# turns on IP forwarding in the kernel, and sets up IP masquerading
# with iptables.
# If no interface is passed it defaults to `usbarmory0`; you can get
# this interface name automatically by writing a systemd .link file
# or using the one located under `systemd/` in this repo (if you are
# using systemd).
#
# Background:
# https://github.com/inversepath/usbarmory/wiki/Host-communication

DEVICE=$1

if [ $# -eq 0 ]
  then
    DEVICE="usbarmory0"
fi

ip link set $DEVICE up
ip addr add 10.0.0.2/24 dev $DEVICE
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.0.0.1/32 -o eth0 -j MASQUERADE
