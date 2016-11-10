#!/bin/sh

result="$(adb get-serialno)"
echo $result

if [ $result = "unknown" ]; then
    exit 1
else
    exit 0
fi
