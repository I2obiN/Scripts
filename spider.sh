#!/bin/sh

# Angel.co URL scrape using WGET
# Usage - ./spider.sh searchterm www.website.com

## Parameters

search=$1
URL=$2

## Spider WGET

wget -r -e robots=off --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" http://$URL 2>&1 | grep '^--' 2>&1 | awk '{ print $3 }' | grep -v '\.\(css\|js\|png\|gif\|jpg\|JPG\)$' &&

## Keyword filter with grep

grep -l -r "$search" $URL >> spider.queue

