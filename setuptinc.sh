#!/usr/bin/env bash
#sudo su -c "useradd tinc -s /bin/bash -m -g $PRIMARYGRP -G $MYGROUP"
#echo $'First line.\nSecond line.\nThird line.' >foo.txt

echo "Getting required libs..."
sudo apt-get update > /dev/null
sudo apt -y install build-essential automake libssl-dev liblzo2-dev libbz2-dev zlib1g-dev git texinfo > /dev/null

echo "getting tinc from git repo"
git clone git@github.com:logbie/tinc.git > /dev/null 2>&1


cd /
cd /home/tinc/tinc/

echo "making tinc"
sh ./configure > /dev/null 2>&1
sudo make > /dev/null 2>&1
sudo make install > /dev/null 2>&1

sudo mkdir -p /usr/local/tinc/lgbenet/hosts/
cd /
cd /usr/local/tinc/lgbenet/

sudo echo $'Name = <INSERT NAME>\nDevice = /dev/net/tun\nAddressFamily = ipv4' >tinc.conf  > /dev/null 2>&1











