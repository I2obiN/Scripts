#!/bin/sh

# Startup script by I2obiN
# Requires mutt setup -- sends your WAN IP to an email address
# Add to crontab -e @reboot or for Ubuntu search "startup applications" and add the script file

curl -s http://whatismijnip.nl |cut -d " " -f 5 | mutt -s "Your Subject" youremail@yahoo.com
