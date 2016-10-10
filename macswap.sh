#!/bin/sh -e

# Bring wireless device down
ifconfig wlan0 down

# Swap mac to random address, if one a wired connection change 'wlan0' to 'eth0'
macchanger -a wlan0

# Bring wireless device up
ifconfig wlan0 up
