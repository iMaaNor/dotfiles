#!/bin/bash

password=`rofi -dmenu -p "Password" -mesg "Enter Your Password to Enable Service" -password -theme squared-nord`

if [[ -n $password ]]; then

	echo $password | sudo -S systemctl start expressvpn.service

	sleep 4

	servers=`expressvpn ls | awk 'NR >= 4 && NR <= 17 {print $1}'`

	choice=`echo -e "$servers\ndisconnect" | rofi -dmenu -p "Choose" -mesg "Choose An Option" -theme squared-nord`

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
fi
