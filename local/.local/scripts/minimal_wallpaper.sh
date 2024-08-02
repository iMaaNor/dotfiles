#!/bin/bash

curl -L -o /home/imaan/.wallpapers/wallpaper 'https://minimalistic-wallpaper.demolab.com/?random'
killall hyprpaper
hyprpaper &
