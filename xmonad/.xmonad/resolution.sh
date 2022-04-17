#!/bin/bash

xrandr --newmode "1920x1080_75.00"  220.64  1920 2056 2264 2608  1080 1081 1084 1128  -HSync +Vsync

xrandr --addmode HDMI3 "1920x1080_75.00"

xrandr --output HDMI3 --mode "1920x1080_75.00"
