#!/bin/sh

set -e
set -x
GREP=""
# if an argument is specified, use that to grep for this as a role
if [ "$1" != "" ]; then
	GREP="|grep $1"
fi
# lava-group is tab separated
for line in `lava-group $GREP | cut -f1` ; do
	# get the ipv4 for this device
	STR=`lava-network query $line ipv4`
	# strip off the prefix for ipv4
	DUT=`echo $STR | sed -e 's/^addr://'`
	ping -c1 -W1 ${IP}
done
