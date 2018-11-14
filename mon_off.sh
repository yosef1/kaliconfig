#!/bin/bash

#echo "Usage: ./mon_mode.sh wlan1|wlan0"
ip link set wlan1 down
iw dev wlan1 set type managed
ip link set wlan1 up
