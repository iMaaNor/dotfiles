#!/bin/bash

STATE=`pactl list sinks | grep "Active Port"`

if [ "$STATE" == "	Active Port: analog-output-lineout" ]; then
	pactl set-sink-port 0 analog-output-headphones && notify-send -a "Control Center" "Sound output set to headphones"
else
	pactl set-sink-port 0 analog-output-lineout && notify-send -a "Control Center" "Sound output set to lineout"
fi
