#!/bin/bash
source /opt/scripta/etc/additional_paramter
cgminer=`ps -ef |grep cgminer |grep -v grep` 
if [ "$cgminer" == "" ]
	then 
	echo `date +"%Y-%m-%d %T"`" cgminer is not running, starting now..."
/usr/bin/screen -dmS cgminer /opt/scripta/bin/cgminer -c /opt/scripta/etc/miner.conf $AdditionalParameter --diff 8 --api-listen --api-network --api-port 4028 --api-mcast --api-allow W:127.0.0.1 --api-mcast-code minereu  --cs 8 --stmcu 0 --hwreset --no-submit-stale --lowmem
fi
