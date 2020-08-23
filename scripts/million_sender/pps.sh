#!/bin/bash
 
INTERVAL="1"  # update interval in seconds
 
if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        echo shows packets-per-second
        exit
fi
 
IF=$1
 
while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_packets`
        T1=`cat /sys/class/net/$1/statistics/tx_packets`
        R11=`cat /sys/class/net/$1/statistics/rx_bytes`
        T11=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_packets`
        T2=`cat /sys/class/net/$1/statistics/tx_packets`
        R22=`cat /sys/class/net/$1/statistics/rx_bytes`
        T22=`cat /sys/class/net/$1/statistics/tx_bytes`
        TXPPS=`expr $T2 - $T1`
        RXPPS=`expr $R2 - $R1`
        
	TXPPS1=`expr $T22 - $T11`
        RXPPS1=`expr $R22 - $R11`


	TXPPS1=`echo $(( TXPPS1 / (1024*1024) ))`
	RXPPS1=`echo $(( RXPPS1 / (1024*1024) ))`

	echo "TX $1: $TXPPS pkts/s RX $1: $RXPPS pkts/s TX $1: $TXPPS1 KB/s RX $1: $RXPPS1 KB/s"
done
