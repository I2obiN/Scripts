#!/bin/sh -e

# Startup script by I2obiN
# Requires mutt setup -- sends your WAN IP to an email address
# NB: Yahoo will not let you send smtp emails from your free account, use gmail

sleep 30s
SEND=$(curl -v -S http://whatismijnip.nl | cut -d ' ' -f 5 | mutt -s 'Your Subject' youremail@yahoo.com &&)
echo "$SEND"
  if [ $? -eq 0 ]
    then
      echo "Recovery Email Sent!"
    else
      echo "Goofed"  
  fi
  
exit 0
# endline
