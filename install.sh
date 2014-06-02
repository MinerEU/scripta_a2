#!/bin/bash
if [ $EUID -ne 0 ];
then
   echo `date +"%Y-%m-%d %T "`"This script must be run as root. use sudo su" 1>&2
   exit 1
fi


is_raspbian=`cat /etc/os-release|grep Raspbian`
if [ "$is_raspbian" == "" ];
then
   echo `date +"%Y-%m-%d %T "`"This script is designed for Raspberry Pi only. Existing now " 1>&2
   exit 1
fi

echo `date +"%Y-%m-%d %T "`"clean up"
backup_path=/opt/minereu_back$(date +"%Y%m%d%H%M%S")
mkdir $backup_path
mv -f /var/www/ $backup_path 2>/dev/null; true
mv -f /opt/scripta/ $backup_path 2>/dev/null; true
mv -f /var/log/minereu   $backup_path 2>/dev/null; true
mkdir -p /var/www

echo `date +"%Y-%m-%d %T "`"prepare dependencies";
apt-get update
apt-get install -y lighttpd unzip wget openssl
apt-get install -y  php5-common php5-cgi php5
mkdir -p /etc/php5/conf.d/
apt-get install -y  php5-rrd  php-auth-sasl php-mail php-net-smtp php-net-socket rrdtool php5-json
apt-get install -y  libjansson4 libexpect-php5 libusb-1.0-0 ntpdate screen

echo `date +"%Y-%m-%d %T "`"setup secure web server"
lighty-enable-mod fastcgi-php
/etc/init.d/lighttpd restart

mkdir /etc/lighttpd/certs
cd /etc/lighttpd/certs
openssl req -new -x509 -keyout lighttpd.pem -out lighttpd.pem -days 365 -nodes -subj "/C=US/ST=TEC/L=LONDON/O=DIS/CN=scripta.minereu.com"
chmod 400 lighttpd.pem
ssl_option=`grep "ssl.pemfile" /etc/lighttpd/lighttpd.conf`
if [ "$ssl_option" == "" ];
	then
echo '$SERVER["socket"] == ":443" { ssl.engine = "enable" ssl.pemfile = "/etc/lighttpd/certs/lighttpd.pem" }' | tee -a  /etc/lighttpd/lighttpd.conf
fi
cd /
/etc/init.d/lighttpd restart


echo `date +"%Y-%m-%d %T "`"installing scripta for A2 miners"
cd /tmp
wget --no-check-certificate -O scriptaming.zip  https://github.com/MinerEU/scripta_a2/archive/master.zip
unzip -o scriptaming.zip
cd scripta_a2-master/
cp -fr etc opt var /

rm -fr /opt/scripta/etc/cron.d/5min/inc;
ln -s /var/www/inc /opt/scripta/etc/cron.d/5min/inc
rm -fr /var/www/rrd ;
ln -s /opt/scripta/http/rrd/ /var/www/rrd

chown -R  www-data /var/www
chown -R  www-data /opt/scripta/
chmod -R +x /var/www/
chmod -R +x  /opt/scripta/bin/
chmod -R +x  /opt/scripta/startup/

#echo "Give sudo to www-data. Note , if you do not want this, please run :"
#echo "rm /etc/sudoers.d/wwwdata"
#echo "www-data ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/wwwdata
#init the graph

echo -e "\n#Minera settings\nminera ALL = (ALL) NOPASSWD: ALL\nwww-data ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/minereu

su www-data -c "/usr/bin/php5 /opt/scripta/etc/cron.d/5min/hashrate"
curl -sSfk https://127.0.0.1/f_graph.php


echo `date +"%Y-%m-%d %T "`"ALL Done!!!"