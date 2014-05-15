#!/bin/sh
echo `date +"%Y-%m-%d %T"`" stopping cgminer"
sudo /usr/bin/screen -S cgminer -X quit
