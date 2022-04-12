#!/usr/bin/env bash

sleep 30

# 1. Is there a default gateway?
# ip route | grep default

# 2. Is there Internet connectivity?
nmcli -t g | grep full

# 3. Is there Internet connectivity via a google ping?
wget --spider http://google.com 2>&1

# 4. Is there an active WiFi connection?
iwgetid -r

if [ $? -eq 0 ]; then
    printf 'Skipping WiFi Connect\n'
else
    printf 'Starting WiFi Connect\n'
    wifi-connect --portal-ssid DucatusX RPi
fi
