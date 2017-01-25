#!/bin/sh

serial_no="$(adb get-serialno)"
echo $serial_no

if [ $serial_no = "unknown" ]; then
    exit 1
else
    exit 0
fi
