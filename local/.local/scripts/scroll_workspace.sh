#!/bin/bash

function clamp {
        min=$1
        max=$2
        val=$3
        python -c "print(max($min, min($val, $max)))"
}

command=$1

current=$(awk 'NR==1' <(hyprctl activeworkspace) | awk '{print $3}')

if [ $command = '+' ]; then
    ws=$(clamp 1 6 $(($current+1)))
    hyprctl dispatch workspace $ws
else
    ws=$(clamp 1 6 $(($current-1)))
    hyprctl dispatch workspace $ws
fi
