#!/bin/bash

ROFI="rofi -no-lazy-grab -show drun -modi drun -show-icons"

case "$1" in
  "mainmenu")
    jgmenu_run
    ;;
  "launcher")
    /home/imaan/.config/rofi/launchers/misc/launcher.sh
    ;;
  "powermenu")
    /home/imaan/.config/rofi/applets/android/powermenu.sh
    ;;
  "windows")
    /home/imaan/.config/rofi/launchers/misc/windows.sh
esac
