#!/bin/sh

set -e
set -x
ifconfig|grep "inet addr"|grep -v "127.0.0.1"|cut -d: -f2|cut -d' ' -f1

