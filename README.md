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

`git clone git@github.com:logbie/tinc.git`
(you will need to deploy key)

next we need to Build the package

1) `sudo sh ./configure`
2) `sudo make`
3) `autoreconf -f -i` (only if there is an error while running make)
4) `sudo make install`

### create tinc config files

First create the tinc directories

* `sudo mkdir -p /usr/local/etc/tinc/lgbenet/hosts/`
* `sudo mkdir -p /usr/local/var/run/`

Next, Start with the `tinc.config` file

First change to the directory
* `cd /` (get back to root)
* `cd /usr/local/tinc/lgbenet/`

 Then open `tinc.conf` we will use nano but you can use your editor of choice
 
 * `sudo nano tinc.conf`
 
on the base node (the one we want to use a a server) paste

> Name = lgbe01  
> Device = /dev/net/tun  
> AddressFamily = ipv4  

on all other nodes the file should look like this *(the addition is in **bold** text)*

> Name = lgbe02  
> Device = /dev/net/tun  
> AddressFamily = ipv4  
> **ConnectTo = lgbe01**

For every node we want we need two things a  keypair and a hosts file

to make a keypair type in the command

`sudo tincd -n lgbenet -K 4096` (where `lgbenet` is the network name)

secondly, the hosts file stored under the /hosts directory in your root tinc network folder
it should contain.

> Address = Your physical ip address  
> Subnet = Your virtual ip address 

### create the public/private keypair

`sudo tincd -n lgbenet -K 4096`

if you have followed the above directions this should automatically  
append the public key to your hosts file,


### create tinc-up/down files

Create the tinc-up file

>#!/bin/sh  
>ip link set $INTERFACE up  
>ip addr add 192.168.100.209 dev $INTERFACE  
>ip route add 192.168.100.0/24 dev $INTERFACE  

Next, Create a tinc-down file

>\#!/bin/sh  
>ip route del 192.168.100.0/24 dev $INTERFACE  
>ip addr del 192.168.100.209 dev $INTERFACE  
>ip link set $INTERFACE down  
 
 ### create services file
 
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


