#!/bin/bash
cgminer=`ps -ef |grep cgminer |grep -v grep` 
if [ "$cgminer" == "" ]
	then 
	echo `date +"%Y-%m-%d %T"`" cgminer is not running, starting now..."
/usr/bin/screen -dmS cgminer /opt/scripta/bin/cgminer -c /opt/scripta/etc/miner.conf  --api-listen  --api-allow "W:127.0.0.1" --api-port "4028"
fi
