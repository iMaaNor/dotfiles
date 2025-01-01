#!/bin/bash

function clamp {
        min=$1
        max=$2
        val=$3
        python -c "print(max($min, min($val, $max)))"
}

command=$1

current=$(awk 'NR==1' <(hyprctl activeworkspace) | awk '{print $3}')

if [ $command = 'n' ]; then
    ws=$(clamp 1 6 $(($current+1)))
    hyprctl dispatch workspace $ws
elif [ $command = "p" ]; then
    ws=$(clamp 1 6 $(($current-1)))
    hyprctl dispatch workspace $ws
elif [ $command = "mn" ]; then
    ws=$(clamp 1 6 $(($current+1)))
    hyprctl dispatch movetoworkspace $ws
elif [ $command = "mp" ]; then
    ws=$(clamp 1 6 $(($current-1)))
    hyprctl dispatch movetoworkspace $ws
fi
