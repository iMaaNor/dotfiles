#!/usr/bin/bash

status=`sudo wg show`
if [[ -z $status ]]; then
        sudo wg-quick up mei
else
	sudo wg-quick down mei
fi
