#!/bin/bash

subvlan=3121
intvlan=3019
base="/nfs-bfs/GCS/Telus_SpeedTest/v6_v8"
yyyymmdd=$(date +%Y%m%d)
WGET="wget --user opwv --password 0p3nw4ve! "
CURL="curl -X POST http://jenkins.bfs.openwave.com:8080/jenkins/job/Pcap_decoder/build --user ojangda:11502d76ca624243d39ae275888a529e00 "

if [ -z "$2" ]
then
echo Suffix not specified in '$1' .
fi

suffix=$2


if [ -z "$1" ]
then
echo 'File or url not specified in $1'
exit 1
elif [ `echo $1 | grep http` ]
then
  filename=$(echo $1 |perl -pi -e's#.*/##g')
  output=$(echo $filename | perl -pi -e"s#.pcap#$suffix#g")  
  basedir="$base/$yyyymmdd/$output"  
  mkdir -p $basedir
  chmod 777 $base/$yyyymmdd
  chmod 777 $basedir
  cd $basedir
  
  if [ "$3" = "0" ]
  then 
    echo "Skipping download"
  else
    echo "Downloading PCAP: $WGET $1"
    $WGET $1
  fi
  input="${basedir}/${filename}"
  chmod 777 $input
  echo URL entered : $1 . Downloading to $input basedir $basedir
  
  subdir=$basedir/$subvlan
  intdir=$basedir/$intvlan
  
  mkdir -p $subdir
  mkdir -p $intdir
  
  subpcap=$subdir/$output.$subvlan.pcap
  intpcap=$intdir/$output.$intvlan.pcap
  
  echo "=================================================================================================="
  echo "Create Subscriber Side PCAP. Input: $input . Output: $subpcap"
  tshark -F pcap -r $input  -w $subpcap "vlan.id==$subvlan"
  chmod -R 777 $basedir
  echo "=================================================================================================="
  subparams="--data-urlencode json={\"parameter\":[{\"name\":\"PCAP_INPUT\",\"value\":\"$subpcap\"},{\"name\":\"OUTPUT\",\"value\":\"csv,graph\"},{\"name\":\"PACKETS_PER_MS\",\"value\":\"true\"},{\"name\":\"TCP\",\"value\":\"true\"}]}"
  echo "Kicking off Jenkins JOB for Subscriber VLAN: $CURL $subparams "
  $CURL $subparams

  echo "=================================================================================================="
  echo "Create Internet Side PCAP. Input: $input . Output: $intpcap"
  tshark -F pcap -r $input -w $intpcap "vlan.id==$intvlan"
  chmod -R 777 $basedir
  echo "=================================================================================================="
  intparams="--data-urlencode json={\"parameter\":[{\"name\":\"PCAP_INPUT\",\"value\":\"$intpcap\"},{\"name\":\"OUTPUT\",\"value\":\"csv,graph\"},{\"name\":\"PACKETS_PER_MS\",\"value\":\"true\"},{\"name\":\"TCP\",\"value\":\"true\"}]}"
  echo "Kicking off Jenkins JOB for Internet VLAN: $CURL $intparams "
  $CURL $intparams
  echo "=================================================================================================="  
 
else
  filename=$(basename $1)
  output=$(echo $filename | perl -pi -e"s#.pcap#$suffix#g")
  base="$(dirname $1)"
  basedir="$base/$output"
  mkdir -p $basedir
  chmod -R 777 $base
  chmod -R 777 $basedir

  mv $1 $basedir
  #echo "Kicking off Jenkins job for $file . Output dir name: $output"
  
  #params="--data-urlencode json={\"parameter\":[{\"name\":\"PCAP_INPUT\",\"value\":\"$input\"},{\"name\":\"OUTPUT_DIRECTORY_NAME\",\"value\":\"$output\"},{\"name\":\"OUTPUT\",\"value\":\"csv,graph\"},{\"name\":\"PACKETS_PER_MS\",\"value\":\"true\"}]}"
  params="--data-urlencode json={\"parameter\":[{\"name\":\"PCAP_INPUT\",\"value\":\"$basedir/$filename\"},{\"name\":\"OUTPUT\",\"value\":\"csv,graph\"},{\"name\":\"PACKETS_PER_MS\",\"value\":\"true\"},{\"name\":\"TCP\",\"value\":\"true\"}]}"
  #echo $params
    
  echo "Kicking off Jenkins JOB: $CURL $params "
  $CURL $params

fi
