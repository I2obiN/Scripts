#!/bin/sh -e

# Bring wireless device down
ifconfig wlan0 down

# Swap mac to random address
macchanger -a wlan0

# Bring wireless device up
ifconfig wlan0 up
