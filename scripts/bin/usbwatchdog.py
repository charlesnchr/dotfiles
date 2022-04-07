''' ----------------------------------------
* Creation Time : Fri 18 Mar 2022 11:02:51 GMT
* Last Modified : Thu 07 Apr 2022 10:38:55 BST
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
    time.sleep(0) # not sure if there's a race here, but it feels like there could be.
    print('reloading xprofile')
    subprocess.run("source ~/.xprofile", shell=True)

def defer_trackpad_init():
    time.sleep(1)
    print('reloading trackpad')
    subprocess.run("source ~/.xprofile", shell=True)
    subprocess.run("libinput-gestures-setup restart", shell=True)


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
    print(device.device_path)

    # my keyboard, from the output of `lsusb`
    found_keyboard = False
    for device_id in ["3434:0111","4b50:1121"]:
        if device_id in device.device_path.lower():
            found_keyboard = True
            break

    # apple magic trackpad
    found_trackpad = False
    for device_id in ["05ac:0265"]:
        if device_id in device.device_path.lower():
            found_trackpad = True
            break


    if found_keyboard:
        # it's the keyboard being added.
        defer_xmodmap()

    if found_trackpad:
        defer_trackpad_init()
