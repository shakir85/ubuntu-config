#!/bin/bash

# Force sleep if lid is closed & power supply isn't plugged.
# To fall-safe if Ubuntu doesn't want to go to bid :)
# Source: https://www.youtube.com/watch?v=hgykHs8bDD8

grep -q closed /proc/acpi/button/lid/LID0/state
if [ $? = 0 ]
then
    grep -q 0 /sys/class/power_supply/AC/online
    if [ $? = 0 ]
    then
        sudo pm-suspend
    fi
fi