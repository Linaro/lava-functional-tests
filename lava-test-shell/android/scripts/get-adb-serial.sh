#!/bin/sh

which adb
echo
# start adb and stop the daemon start message from appearing in $result
adb get-serialno || true # start daemon if not yet running.
result=`adb get-serialno 2>&1 | tail -n1`
if [ "$result" = "unknown" ]; then
    echo "ERROR: adb get-serialno returned" $result
    exit 1
else
    echo "adb get-serialno returned" $result
    echo $result > adb-connection.txt
    exit 0
fi
