#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
set +x
LANG=POSIX

ho='500X'
baseDir='/bfs-build/build-info/solutioninstaller_7.X_RH7-Linux.latest/RedHat7/handoff/'

ordbBackDir='/spare/ordb/28032019/'
siPath="${baseDir}/dpg/bin"
localDir='/spare/install/'
DWBfile='sdrcm-devload-dwb.xlsx'
DWBfile="/spare/install/${DWBfile}"
nodeList="${localDir}nodes_list.txt"
passwd='helsinki'

uninstalSystem()
{
    echo "==============================================================================="
    echo "= UNINSTALLING                                                                ="
    echo "==============================================================================="
    unistallScript="${localDir}remoteClean.sh"

    yes YES | $unistallScript "$nodeList"

}


removePreviousPackets ()
{
    echo "==============================================================================="
    echo "$ho REMOVE FILES FROM PREVIOUS INSTALLATION                                    "
    echo "==============================================================================="

    rm -rvf /staging/dp/* /staging/preinstall /staging/SolutionInstaller /staging/dpg/*
}

genDPG ()
{
    cd "$siPath"
    ./dpg.rb -w "$DWBfile" -a $workbook -m GenAndPush -d -o /tmp/DPG_$ho/ -p "$passwd" --debug --debug-parse

}

genSshKey ()
{
    echo "==============================================================================="
    echo "$ho  GENERATE SSH KEYS                                                         "
    echo "==============================================================================="
    cd /staging/preinstall/1.0/bin 
    ./setupPasswordless.sh "$nodeList"
}

preInstall ()
{
    echo "==============================================================================="
    echo "$ho  PREINSTALL                                                                "
    echo "==============================================================================="
    cd /staging/preinstall/1.0/bin 
    ./remotePreinstall.sh "$nodeList" setup
}

siRun ()
{
    echo "==============================================================================="
    echo "$ho  RUNNING THE SOLUTION INSTALLER                                            "
    echo "==============================================================================="
    cd /staging/SolutionInstaller/1.0/bin 
    ./SolutionInstall.pl -u root -f /staging/dp/dp.tar -d 
#	su - opwv { bash -c "cd /staging/SolutionInstaller/1.0/bin; id;
#	./SolutionInstall.pl -u opwv -f /staging/dp/dp.tar -d" }
}

versionDetect()

# Detect OAM/Integra version(s)
{
	local detectedProduct="$1"
	ls -1tF /opt/opwv/${detectedProduct}/|awk -F '/' '/[0-9\.]+\//{if (NR=1) print $1}'
}

installTCPAccLicense(){
	local licenseFile='/users/jstanule/TCPAccLicense/tcpacc.lic'
	local pathToLicense='/opt/opwv/TCPAccLicense/'
	local fileName='tcpacc.lic'
		echo "==============================================================================="
		echo "  Installing appex license file...                                             "
		echo "==============================================================================="
	for feDN in 'bfs-dl360g7-73'; do
		ssh root@${feDN} "mkdir -pv ${pathToLicense}"
		scp "$licenseFile" "root@${feDN}:${pathToLicense}${fileName}"
	done
}

ordbBackup ()
{
	local workDir="$1"
	OAMVersion=$(versionDetect oam)
	if [[ -f "/opt/opwv/oam/${OAMVersion}/mysql/bin/mysqldump" ]]; then
		echo "==============================================================================="
		echo "  CREATING ORDB BACK UP FOR $workDir                                                        "
		echo "==============================================================================="
		cd "$workDir"
		/opt/opwv/oam/${OAMVersion}/mysql/bin/mysqldump --socket=/var/opt/opwv/oam/tmp/mysql-v${OAMVersion}.sock \
			-uroot -pch4ngeme ordb --no-data | lbzip2 > "ordb.no-data.$(date +'%Y_%m_%d__%H_%M').sql.bz2"
		/opt/opwv/oam/${OAMVersion}/mysql/bin/mysqldump --socket=/var/opt/opwv/oam/tmp/mysql-v${OAMVersion}.sock \
			-uroot -pch4ngeme ordb --no-create-info | lbzip2 > "ordb.no-create-info.$(date +'%Y_%m_%d__%H_%M').sql.bz2"
		cd - 
	fi
}

if [ -z "$1" ]; then 
  workbook="../AppCorePlusCCPlusSTMWB.xlsx"; 
else 
  workbook=$1; 
fi
echo "using workbook $workbook" 

sleep 2s

echo "==============================================================================="
echo "= $ho INSTALLING                                                              ="
echo "==============================================================================="

ordbBackup "$ordbBackDir"
##genSshKey
uninstalSystem
removePreviousPackets

genDPG
##genSshKey
preInstall
#installTCPAccLicense
siRun
ordbBackup "$ordbBackDir"
