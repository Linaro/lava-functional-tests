#!/usr/bin/python

import re
import subprocess


def main():
    result = "pass"
    try:
        data = subprocess.check_output(["python-coverage", "report"])
    except OSError:
        result = "fail"
        data = ""
    except subprocess.CalledProcessError:
        result = "fail"
        data = ""

    pattern = re.compile("(?P<test_case_id>[a-z\/_]+)\s+\d+\s+\d+\s+(?P<measurement>\d+)(?P<units>%)$")
    values = []
    for line in data.split('\n'):
        if line is not "":
            m = pattern.match(line)
            if m:
                subprocess.Popen([
                    "lava-test-case",
                    m.group(1),
                    "--result",
                    "pass",
                    "--measurement",
                    m.group(2),
                    "--units",
                    m.group(3)
                ])

if __name__ == '__main__':
    main()
