#!/bin/bash

select=$(echo -e "Xmonad\nXmobar\nQutebrowser" | dmenu)

case $select in
"Xmonad")
kitty -e nvim /home/imaan/.xmonad/xmonad.hs
;;
"Xmobar")
kitty -e nvim /home/imaan/.config/xmobar/xmobarrc
;;
"Qutebrowser")
kitty -e nvim /home/imaan/.config/qutebrowser/config.py
;;
esac
