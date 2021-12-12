#!/bin/bash

status=`safeeyes --status | grep Disabled`

if [[ -z $status ]]; then
	safeeyes --disable
else
	safeeyes --enable
fi
