#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess


def main():
    result = "pass"
    try:
        ver = subprocess.check_output(["./version.py"])
    except OSError:
        result = "fail"
        ver = 0
    except subprocess.CalledProcessError:
        result = "fail"
        ver = 0
    subprocess.Popen(["lava-test-case", "code-version-%s" % ver, "--result", result])
    return 0

if __name__ == '__main__':
    main()
