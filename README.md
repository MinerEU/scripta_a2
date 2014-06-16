Original work refer to https://github.com/scriptamining/scripta

Zeus Miner controller

# INSTALL NOTE:
## Zeus MinerEU  version dedicatd for [MinerEU.com](https://MinerEU.com)

Download : [SD card image]()

Note: you can use a brand new SDcard or any RaspberryPi Card. you can install the application before your Zeus arrives and simply swap the SD card on Zeus

## Quick command 

If you know linux well, following command is all you need.
```
curl -fsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/zeus/install.sh|sudo bash
```

## Detailed steps if you need more help
### 1. ssh to your raspberry pi.
  * on Windows, you need [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/)
  * on Linux/Mac OS, you can simply launch terminal
```
ssh pi@your_pi_ip_address
```

### 2. Once you are in , switch to root
```
sudo su
```

### 3. Run bash script to setup on Raspbian
   User located in North American/Europe
```
curl -fsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/zeus/install.sh|bash
```


   User located in mainland china, run [中国客户，请使用以下命令]
```
mkdir /etc/apt/sources.list.d/bk
mv /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/bk
echo  "deb http://mirrors.ustc.edu.cn/raspbian/raspbian/   wheezy main contrib non-free rpi" > /etc/apt/sources.list

curl -kfsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/zeus/install.sh|bash
```
### 4. Reboot your Pi. and open the ip's ip in your browser . and login with Password: minereu
