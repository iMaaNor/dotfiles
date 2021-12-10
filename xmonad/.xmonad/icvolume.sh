#!/bin/bash

mute=`pamixer --get-mute`

if [ $mute == "true" ]; then
	echo '' 
else
	volume=`pamixer --get-volume`
	if [ $volume -le 30 ]; then
		echo ''
	else
		echo ''
	fi
fi
