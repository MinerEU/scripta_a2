#!/bin/bash
cgminer=`ps -ef |grep cgminer |grep -v grep` 
if [ "$cgminer" == "" ]
	then 
	echo "cgminer is not running, starting now..."
/usr/bin/screen -dmS cgminer /usr/local/bin/cgminer -c /opt/scripta/etc/miner.conf --A1Pll1 1200 --A1Pll2 1200 --A1Pll3 1200 --A1Pll4 1200 --A1Pll5 1200 --A1Pll6 1200 --diff 8 --api-listen --api-network --cs 8 --stmcu 0 --hwreset --no-submit-stale --lowmem
fi