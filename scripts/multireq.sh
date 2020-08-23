#!/bin/bash

# This script opens 4 terminal windows.
#$1 --> number  of connection required 
i="0"
while [ $i -lt $1 ]
do
 curl --interface 192.168.199.125  http://192.168.200.125:8080/metric_10mb --connect-timeout 3 &
 curl --interface 192.168.199.126  http://192.168.200.126:8080/metric_10mb --connect-timeout 3 &
echo " Requesting $i"
i=$[$i+1]
done
