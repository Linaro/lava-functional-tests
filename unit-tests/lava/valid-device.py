#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  valid-device.py
#  
#  Copyright 2016 Neil Williams <codehelp@debian.org>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

import argparse
import xmlrpclib
import subprocess


def testcase(hostname, result):
    subprocess.Popen(["lava-test-case", "%s-validity" % hostname, "--result", result])
    return 0


def main():
    parser = argparse.ArgumentParser(description='lava test case device helper')
    parser.add_argument(
        '--instance', type=str, required=True,
        help='Name of the instance to check')
    parser.add_argument(
        '--hostname', default=None, type=str,
        help='Device to check (all pipeline devices if not used)')
    args = parser.parse_args()

    connection = xmlrpclib.ServerProxy("http://%s//RPC2" % args.instance)
    if args.hostname:
        data = connection.scheduler.validate_pipeline_devices(args.hostname)
    else:
        data = connection.scheduler.validate_pipeline_devices()
    devices = data.data.split('\n')
    for device in devices:
        if not device:
            continue
        key = device.split(':')[0]
        print("Checked %s: %s" % (key, device))
        if 'Valid' in device:
            testcase(key, 'pass')
        else:
            testcase(key, 'fail')
            print(device)

if __name__ == '__main__':
    main()
