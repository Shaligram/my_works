#!/bin/bash

DATE=`date +%Y%m%d-%H%M`
STG_PATH=/staging
PREINSTALL_DIR=preinstall
SOLUTIONINSTALLER_DIR=SolutionInstaller
PREINSTALL_PATH=$STG_PATH/$PREINSTALL_DIR
SOLUTIONINSTALLER=$STG_PATH/$SOLUTIONINSTALLER_DIR
PREINSTALL_DIR=$PREINSTALL_PATH/1.0

function remove_ubuntu_pkgs() {
    echo "*** Uninstalling all opwv packages:"
    dpkg -l | grep opwv
    echo ""

    dpkg-query -W -f='${binary:Package}\n' | grep opwv | xargs dpkg --purge

    echo "*** List of OPWV packages on the system after uninstall:"
    dpkg -l | grep opwv
    echo ""
}

function remove_redhat_pkgs() {
    echo "*** Uninstalling all opwv packages:"
    rpm -qa |grep -i opwv
    echo ""

    for pkg in `rpm -qa |grep -i opwv`
    do
        echo "*** Removing Package: $pkg"
        rpm -ev --nodeps  $pkg
    done

    echo "*** List of OPWV packages on the system after uninstall:"
    rpm -qa | grep -i opwv
}

function remove_pkgs() {
    OS=`lsb_release -si`
    if [[ $OS == RedHatEnterpriseServer ]]; then
        remove_redhat_pkgs
    elif [[ $OS == Ubuntu ]]; then
        remove_ubuntu_pkgs
    else
        echo "Unsupported OS: $OS"
    fi
}

me=`basename $0`

# Kill all opwv processes.
if [[ `ps -ef | grep opwv | grep -v grep | grep -v $me | wc -l` -gt 0 ]]
then
    echo "*** Killing all opwv user processes"
    kill -9 `ps -ef | grep opwv | grep -v grep | grep -v $me | awk '{print $2}'`
fi

# Rollback preload config for libreuseaddr_hook.so
echo "Rolling back /etc/ld.so.preload"
sed -i '/.*libreuseaddr_hook.so/d' /etc/ld.so.preload

echo "Rolling back LD_PRELOAD from /etc/environment"
sed -i '/LD_PRELOAD=.*libreuseaddr_hook.so/d' /etc/environment

# Uninstall packages
remove_pkgs

echo "*** Removing all OPWV files and directories"
rm -rf /opt/opwv/*
rm -rf /etc/opwv
rm -rf /var/opt/opwv/oam/*
rm -rf /var/opt/opwv/PCCA
rm -rf /var/opt/opwv/oam_installer/
rm -f /etc/opwv/.scaLock*
rm -f /var/opt/opwv/oam/tmp/oamcs.lck*
cat /dev/null > /var/opt/opwv/logs/OamApp.log
rm -f /var/opt/opwv/logs/cli.log
rm -f /var/opt/opwv/logs/scaInit.log
rm -f /var/opt/opwv/logs/update_manager.log
rm -rf /var/opt/opwv/logs/snmp/*
rm -rf /var/opt/opwv/tmp
rm -rf /var/opt/opwv/reporting
rm -rf /var/opt/opwv/aggregates
rm -rf /var/tmp/oam_filesync_staging
rm -rf /var/tmp/SolutionInstaller
rm -f /etc/sudoers.d/*-opwv
rm -f /etc/security/limits.d/95-opwv.conf
rm -f /tmp/preInstallCheckFile
rm -rf /tmp/.AgentSockets
rm -rf /etc/yum.repos.d/opwvPreinstall.repo

echo "*** Remove OPWV logrotate config files ***"
for file in `cat $PREINSTALL_DIR/conf/logfiles.list`;
do
    filename=`echo $file | awk -F '/' '{print $NF}' | sed -e 's/\.log/ /g' -e 's/\.out/ /g'`
    rm -rf /etc/logrotate.d/$filename
done

if [ "$SOLUTIONINSTALLER" != "" ]
then
    if [ -d "$SOLUTIONINSTALLER" ]
    then
        rm -rf $SOLUTIONINSTALLER
    fi
fi

rm -f /usr/sbin/enableMellanoxVF.sh
rm -f /usr/sbin/listMellanoxVF.sh
rm -f /usr/lib/systemd/system/mlx5_vf.service
rm -f /etc/systemd/system/multi-user.target.wants/mlx5_vf.service
rm -f /tmp/owm.bifurcation.enabled
