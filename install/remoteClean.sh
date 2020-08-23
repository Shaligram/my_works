#!/bin/bash

# Specify ssh user
user=root
DATE=`date +%Y%m%d-%H%M`

STARTDATE=`date`
ST=$(date +%s)


# source pre installation function file
STG_PATH=/staging
PREINSTALL_DIR=preinstall
PREINSTALL_PATH=$STG_PATH/$PREINSTALL_DIR/1.0
#PREINSTALL_PATH=$STG_PATH/$PREINSTALL_DIR/1.0

DP_DIR=dp
DP_PATH=$STG_PATH/$DP_DIR

CLEAN=$PREINSTALL_PATH/bin/clean.sh

transferFiles()
{

	if [ -z "$host" ]
	then
		echo '$host not defined. Skipping ...'
	else	
		echo "*** Transferring clean-up script $host"
		scp $CLEAN $user@$host:$CLEAN
	fi
}


runClean()
{
	for host in `cat $HOSTLIST`
	do
	  if echo $host | grep "^#"
	  then
	    dummy=1
	    echo "Comment found: $host. Skipping..."
	  else
	    dummy=0
	    echo "######################################################################################################"
		 echo "Cleaning up host $host"
		 echo "######################################################################################################"
	    HST=$(date +%s)
	 	 echo "*** Testing SSH connection to $host"
		 sshtest=`ssh $host hostname`

		 if [ -z "$sshtest" ]
		 then
			echo "*** SSH connection to $host failed. Skipping host ..."
			failed=1
		 else
			failed=0

			echo "*** SSH connection to $host passed."
			transferFiles
			echo "*** Running clean-up on host: $host"
			echo "******************************************************************************************************"
			ssh $user@$host $CLEAN
			echo "******************************************************************************************************"
   	 fi

    	 HET=$(date +%s)
		 HDURATION=$((HET - HST))
		 echo "$host - Start time: $HST; End time: $HET; Clean-up duration: $HDURATION s"	  	 
     fi   
	done
    	
}


if [ -z "$1" ]
then
  echo "No host list specified in $ 1."
  echo "Usage: ./remoteClean.sh <hostlist>"
  echo "$ 1 = Host List"
  exit 1
fi

  
HOSTLIST=$1

if [ ! -f $HOSTLIST ]
then
  echo "Hostlist file: $HOSTLIST not found"
  exit 2
fi

# Check for clean.sh
if [ ! -f $CLEAN ]
then
  echo "Cleanup script: $CLEAN not found"
  exit 3
else
  chmod +x $CLEAN
fi


echo "Are you sure you want to Uninstall everything on the following hosts? "
cat $HOSTLIST
echo "Enter YES to proceed:"
read -e ANSWER

if [ "$ANSWER" == "YES" ] 
then
	echo "You have answered YES. Are you 100% sure? Enter YES to proceed:"
	read -e A2
	if [ "$A2" == "YES" ]
	then
		echo "Starting cleanup process ... "
		echo ""
		runClean
	else
		echo "Clean-up Aborted"
		exit 8
	fi
else
	echo "Aborting Clean-up process"
	exit 9
fi


ENDDATE=`date`
ET=$(date +%s)
DURATION=$((ET - ST))
    	  
echo "######################################################################################################"
echo "Clean-up Summary"
echo "Start Time: $STARTDATE; End Time: $ENDDATE; Duration: $DURATION s"
echo "######################################################################################################"