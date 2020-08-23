
echo "0" > /var/opt/opwv/logs/scaInit.log
vppctl proxy-debug print

vppctl pcap trace rx tx off



