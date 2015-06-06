#!/bin/sh

rgrep -In FIXME
FIXME=`rgrep -In FIXME | wc -l`
if [ $FIXME = 0 ]; then
	lava-test-case fixme --result pass
else
	lava-test-case fixme --result pass --measurement $FIXME --units items
fi

rgrep -In TODO
TODO=`rgrep -In TODO | wc -l`
if [ $TODO = 0 ]; then
	lava-test-case todo --result pass
else
	lava-test-case todo --result pass --measurement $TODO --units items
fi
