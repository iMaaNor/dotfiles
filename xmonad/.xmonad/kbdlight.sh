#!/bin/bash

STATE=$(brightnessctl --device='input4::scrolllock' g)

if [ "$STATE" -eq 1 ]; then
	brightnessctl --device='input4::scrolllock' set 0 && notify-send -a "Control Center" "Keyboard light turned on"
else
	brightnessctl --device='input4::scrolllock' set 1 && notify-send -a "Control Center" "Keyboard light turned off"
fi
