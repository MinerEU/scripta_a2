Original work refer to https://github.com/scriptamining/scripta

# Main feature
 1. Scripta interface: this gives you all the goodies that scripta offers
 2. Improvements for A2chips: A2 chip temperature , A2 chip cores etc
 3. MinerEU watchdog checkes cgminer every 30s ensure always running
 4. Startup mining. will auto start cgminer upon reboot

### Planning feature
Cluster version to manage large mining farm.
 

# INSTALL NOTE:
## A2BOX && A2MINI  MinerEU modified version dedicatd for [MinerEU.com](https://MinerEU.com) 

Download : [SD card image](https://mega.co.nz/#!t91g2BRK!qW2P1EeVZ_1M8QTHPjuEQWAgq-nK3Tlfgskl9itAo7A)

Note: you can use a brand new SDcard or any RaspberryPi Card. you can install the application before your A2 arrives and simply swap the SD card on A2 

## Quick command 

If you know linux well, following command is all you need.
```
curl -fsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/master/install.sh|bash
```

## Detailed steps if you need more help
### 1. ssh to your A2 device.
  * on Windows, you need [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/)
  * on Linux/Mac OS, you can simply launch terminal
```
ssh pi@your_a2_ip_address
```
  If you use a new SDCard, simply login and run our script below, if you use innosilicon's SD card, it is locked with a different password. and the IP address might be labelled 
  * Password for batches before 10th May 2014: **raspberry** or **stone2014**
  * Password for batches after 10th May 2014: **innosilicon**

### 2. Once you are in , switch to root
```
sudo su
```

### 3. Run bash script to setup on Raspbian
   User located in North American/Europe
```
curl -fsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/master/install.sh|bash
```


   User located in mainland china, run [中国客户，请使用以下命令]
```
mkdir /etc/apt/sources.list.d/bk
mv /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/bk
echo  "deb http://mirrors.ustc.edu.cn/raspbian/raspbian/   wheezy main contrib non-free rpi" > /etc/apt/sources.list

curl -kfsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/master/install.sh|bash
```
### 4. Reboot your Pi. and open the ip's ip in your browser . and login with Password: minereu
