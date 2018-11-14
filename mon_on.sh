#!/bin/bash

#echo "Usage: ./mon_mode.sh wlan1|wlan0"
ip link set wlan1 down
iw dev wlan1 set type monitor
ip link set wlan1 up

#iw dev wlan1 set type managed
