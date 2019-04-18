Logbie tinc
------------
***
First we need to install the prereqs to build the tinc pakage.
### ubuntu
`sudo apt install build-essential automake libssl-dev liblzo2-dev libbz2-dev zlib1g-dev git texinfo`

Next, create a `tinc` user and give them sudo ablity

>1) `adduser tinc`
>2) `adduser tinc sudo`

if we dont want to have to enter a password **everytime** we sudo 

 1) `visudo` (as root)
 2) add the line `%sudo   ALL=(ALL) NOPASSWD: ALL`
 
 (make sure thats the only line that modifies the %sudo group as any otherline may override this one.)

Now, we need to clone the git repository to our local machine

`git clone https://github.com/logbie/tinc.git`

next we need to Build the package
1) `cd tinc/`
2) `sudo sh ./configure`
3) `sudo make`
4) `autoreconf -f -i` (only if there is an error while running make)
5) `sudo make install`

### create tinc config files on all nodes

First create the tinc directories

* `sudo mkdir -p /usr/local/etc/tinc/lgbenet/hosts/`
* `sudo mkdir -p /usr/local/var/run/`

Next, Start with the `tinc.config` file

First change to the directory
* `cd /usr/local/etc/tinc/lgbenet/`

 Then create `tinc.conf` we will use nano but you can use your editor of choice
 
 * `sudo nano tinc.conf`

on the base node (the one we want to use a a server) paste

> Name = lgbe01  
> Device = /dev/net/tun  
> AddressFamily = ipv4  

on all other nodes the file should look like this *(changes are in **bold** text)*

> **Name = lgbe02**  
> Device = /dev/net/tun  
> AddressFamily = ipv4  
> **ConnectTo = lgbe01**

Secondly, For every node we also need two things a host file and keypairs.
create the host's file:

* `nano /usr/local/etc/tinc/lgbenet/hosts/lgbe01`

ensure the file name is same as the name you defined in tinc.conf, it should contain: 

> Address = Your physical ip address  
> Subnet = Your subnet using CIDR notation 

### create the public/private keypair

to make a keypair type in the command

`sudo tincd -n lgbenet -K 4096` (where `lgbenet` is the network name)

if you have followed the above directions this should automatically  
append the public key to your host's file and place your priv key in tinc's root folder.

Ensure everynode has a copy of the hostfile from each node under the hosts/ folder.

### create tinc-up/down files on all nodes

Create the tinc-up script for each node using their respective Address and Subnet.

>#!/bin/sh  
>ip link set $INTERFACE up  
>ip addr add 192.168.100.209 dev $INTERFACE  
>ip route add 192.168.100.0/24 dev $INTERFACE  

Next, Create a tinc-down script for each node using their respective Address and Subnet.

>\#!/bin/sh  
>ip route del 192.168.100.0/24 dev $INTERFACE  
>ip addr del 192.168.100.209 dev $INTERFACE  
>ip link set $INTERFACE down  
 
ensure sure the scripts are executable:

`chmod +x tinc-up tinc-down`
 
 
 ### create services file on all nodes
 
 `nano /lib/systemd/system/tinc.service`
 
 it should contain:
 
>  [Unit]  
>  Description=Tinc net linodeVPN  
>  After=network.target  
>  
>  [Service]  
>  Type=simple  
>  WorkingDirectory=**/usr/local/etc/tinc/*lgbenet***  
>  ExecStart=**/usr/local/sbin/tincd -n *lgbenet* -D -d3**  
>  ExecReload=**/usr/local/sbin/tincd -n *lgbenet* -kHUP**  
>  TimeoutStopSec=5  
>  Restart=always  
>  RestartSec=60  
>  
>  [Install]  
>  WantedBy=multi-user.target  

enable the service to start when linux boots

`sudo systemctl enable tinc.service`

start tinc service and all hosts 

`systemctl start tinc`

ensure you see your new network vpn tunnel and its activity listed using

`ifconfig`

if needed to troubleshoot use `systemctl status tinc` and look for tinc logs under `/var/log/syslog`



