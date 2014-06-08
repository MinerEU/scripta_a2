#!/bin/bash
cgminer=`ps -ef |grep cgminer |grep -v grep` 
if [ "$cgminer" == "" ]
	then 
	echo `date +"%Y-%m-%d %T"`" cgminer is not running, starting now..."
/usr/bin/screen -dmS cgminer /opt/scripta/bin/cgminer -c /opt/scripta/etc/miner.conf --diff 8 --api-listen --api-network --cs 8 --stmcu 0 --hwreset --no-submit-stale --lowmem
fi
