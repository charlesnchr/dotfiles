''' ----------------------------------------
* Creation Time : Fri 18 Mar 2022 11:02:51 GMT
* Last Modified : Fri 18 Mar 2022 11:23:05 GMT
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'''

#! /usr/bin/env python3

import pyudev
import time
import subprocess

ctx = pyudev.Context()
monitor = pyudev.Monitor.from_netlink(ctx)
monitor.filter_by("input")

def defer_xmodmap():
    time.sleep(1) # not sure if there's a race here, but it feels like there could be.
    print('reloading xprofile')
    subprocess.run("source ~/.xprofile", shell=True)


for device in iter(monitor.poll, None):
    print('poll')

    # there might be a way to add the action condition to the filter, but I couldn't find it
    if device.action != "add":
        continue


    print('added')

    # ensure the KB is initialized -- not sure if this is actually a needed check
    if not device.is_initialized:
        continue

    print('is init')

    # my keyboard, from the output of `lsusb`
    if not "3434:0111" in device.device_path:
        continue

    print('q2 keyboard')

    # it's the keyboard being added.
    defer_xmodmap()