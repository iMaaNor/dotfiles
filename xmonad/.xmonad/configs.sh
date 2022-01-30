#!/bin/bash

select=$(echo -e "Xmonad Config\nXmobar Config\nQutebrowser Config" | dmenu)

case $select in
"Xmonad Config")
kitty -e nvim /home/imaan/.xmonad/xmonad.hs
;;
"Xmobar Config")
kitty -e nvim /home/imaan/.config/xmobar/xmobarrc
;;
"Qutebrowser Config")
kitty -e nvim /home/imaan/.config/qutebrowser/config.py
;;
esac
