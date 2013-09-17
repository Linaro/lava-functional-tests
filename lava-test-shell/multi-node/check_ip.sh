#!/bin/sh

set -e
#set -x
echo "Testing all members in the group"
for line in `lava-group | sed -e 's/\(.*\)\s.*/\1/'` ; do
	# get the ipv4 for this device
	STR=`lava-network query $line ipv4`
	# strip off the prefix for ipv4
	DUT=`echo $STR | sed -e 's/<LAVA.*>//g' | tr -d '\n' | sed -e 's/\s//g' | sed -e 's/^addr://'`
	ping -c1 -W1 ${DUT}
done
