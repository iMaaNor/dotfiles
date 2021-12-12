#!/bin/bash

status=`safeeyes --status | grep Disabled`

if [[ -z $status ]]; then
	echo ON
else
	echo OFF
fi
