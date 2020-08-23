#tcpdump -i $1 -p -nn host 2001:200:0:abcd::125 | grep "IP" | awk '{print$3 ,$4 ,$5, $7, "S:" $9, "A:" $11,$12,$13, "Len:" $21  }' | sed 's/://'
if [ $1 == 0 ]
then
echo "IPv4 capture"
tcpdump -i $2 -p -nn host 192.168.200.125 -U | grep "IP" | awk '{print$3 ,$4 ,$5, $7, "S:" $9, "A:" $11,$12,$13, "Len:" $21  }' | sed 's/://' 
else
echo "IPv6 capture"
tcpdump -i $2 -p -nn host 2001:200:0:abcd::125 | grep "IP" | awk '{print$3 ,$4 ,$5, $7, "S:" $9, "A:" $11,$12,$13, "Len:" $21  }' | sed 's/://' > /tmp/dump
fi
