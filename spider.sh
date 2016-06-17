#!/bin/bash

# URL keyword scrape using WGET, scrape URLS by keyword
# Usage - bash ./spider.sh searchterm www.website.com parameters
# To debug - bash -x ./spider.sh etc

## Parameters

search=$1
URL=$2
bool=true

## Spider WGET
echo " " && echo "WGET started ..." &

## Website robot countermeasure evasion -- wait time of 7 secs, random, header, obviously changed user-agent. Also filters out images and css sheets
wget -w 7 --random-wait -c -nd -b -r -e robots=off --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" http://$URL/$3 2>&1 | grep '^--' 2>&1 | awk '{ print $3 }' | grep -v '\.\(css\|js\|png\|gif\|jpg\|JPG\)$' &

echo "Starting search for keyword .." & echo " " &

## Sleep to let wget initialize, found this helped in general depending on the site and scope of the scrape
sleep 5s 
echo "Please wait.. wget can take a while!" & echo " " &

## Infinite loop to continually process profile matches, while wget pulls in the site
while [ $bool=true ]
 do
    ## Assigns matches with the keyword to an array	
    PROFILES=($(grep -l -r "$search"))
  	for x in ${PROFILES[*]}
	  do	
		## Cleanup if ctrl-c termination ..
		trap ctrl_c INT
		function ctrl_c() {
		sleep 1s
		echo " " && echo "Shutting down .." && echo "Sleep for 5s .."
		sleep 1s && echo "." && sleep 1s && echo ".." && sleep 1s && echo "..." && sleep 1s && echo "...." && sleep 1s && echo "....." && echo "Process terminated.." &&
		killall bash && kill $$
		}
		
		## Drops any clobber from URL -- Pretty important depending on the site layout/sitemap. If you're going to hit the same page multiple times you'll get "clobber" with WGET
		x="$(echo $x | sed 's/.1//' | sed 's/.2//' | sed 's/.3//' | sed 's/?desktop//' | sed 's/?desktop=0//' | sed 's/?desktop=1//' | sed 's/?desktop=2//' | sed 's/=0//')"	

		## If statement to check if profile is already in the queue (text file)
   		if grep -q $x crawler.queue; then
			sleep 1s && echo "Looking ... "
		else
			echo "Found one! Added to crawler.queue"
			echo "$x" >> crawler.queue
		fi
	  done
 done
