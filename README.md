Original work refer to https://github.com/scriptamining/scripta

# MinerEU modified version dedicatd for [MinerEU.com](MinerEU.com) & [JustAsic.com](justasic.com)

## For technical reader Setups to install:

### 1. ssh to your A2 device.
  * on Windows, you need [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/)
  * on Linux/Mac OS, you can simply launch terminal
```
ssh pi@your_a2_ip_address
```
  * Password for batches before 10th May 2014: **raspberrypi**
  * Password for batches after 10th May 2014: **innosilicon**

### 2. Once our are in , siwtch to root
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

curl -fsSL https://raw.githubusercontent.com/MinerEU/scripta_a2/master/install.sh|bash
```

