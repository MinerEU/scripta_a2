#!/bin/bash
cgminer=`ps -ef |grep cgminer |grep -v grep` 
if [ "$cgminer" == "" ]
	then 
	echo `date +"%Y-%m-%d %T"`" cgminer is not running, starting now..."
/usr/bin/screen -dmS cgminer /opt/scripta/bin/cgminer -c /opt/scripta/etc/miner.conf --A1Pll1 1280 --A1Pll2 1280 --A1Pll3 1280 --A1Pll4 1280 --A1Pll5 1280 --A1Pll6 1280 --diff 8 --api-listen --api-network --cs 8 --stmcu 0 --hwreset --no-submit-stale --lowmem
fi
