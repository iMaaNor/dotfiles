#!/bin/bash

myip=`curl -s icanhazip.com`

location=`geoiplookup $myip | sed -En 's/GeoIP Country Edition: //p' | awk '{print $1}' | sed -En 's/,//p'`

echo "$location"
