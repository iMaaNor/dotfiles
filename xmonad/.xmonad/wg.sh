#!/usr/bin/bash

status=`sudo wg show`
if [[ -z $status ]]; then
	echo "OFF"
else
	echo "ON"
fi

