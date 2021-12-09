#!/bin/bash

layout=$(xset -q | grep LED | awk '{ print $10 }')

if [ $layout -eq 00000002 ]; then
	xkblayout-state set 1
else
	xkblayout-state set 0
fi


