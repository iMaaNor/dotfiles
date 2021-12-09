#!/bin/bash


choice=`echo -e "" | rofi -dmenu -p "Choose" -mesg "Choose An Option" -theme squared-nord`

if [[ -z $choice ]]; then
	echo "cancled"
elif [[ "$choice" == "disconnect" ]]; then
	expressvpn disconnect
	echo $password | sudo -S systemctl stop expressvpn.service
else
	expressvpn disconnect
	sleep 1
	expressvpn connect $choice
fi
