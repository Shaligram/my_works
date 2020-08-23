
echo "0" > /var/opt/opwv/logs/scaInit.log
vppctl proxy-debug disable
vppctl proxy-debug enable num 9000000 size 1200 flags $2
vppctl proxy-debug clear

vppctl pcap trace rx tx off
vppctl pcap trace rx tx max 9000000 intfc $1 file client_fe.pcap max-bytes-per-pkt 100



