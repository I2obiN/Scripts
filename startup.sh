#!/bin/sh

# Startup script by I2obiN
# Requires mutt setup -- sends your WAN IP to an email address

$wanip = curl -s http://whatismijnip.nl |cut -d " " -f 5
echo $wanip | mutt -s "Your Subject" youremail@yahoo.com
