#!/bin/sh

pylint -d line-too-long -d missing-docstring $1 2>/dev/null > pylint.log
RET=`echo $?`
if [ "$RET" = "1" ]; then
	lava-test-case pylint --result fail
fi
rating=`grep "Your code has been rated at" pylint.log | awk '{print $7}'|sed -e 's#/.*##'`
percent=`echo $rating*10 | bc -l`
lava-test-case pylint --result pass --measurement ${percent} --units %
lava-test-case-attach pylint pylint.log text/plain
