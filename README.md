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
3) `autoreconf -f -i` (only if there is an error whilke running make)
4) `sudo make install`

### create tinc config files

First create the tinc directories

* `sudo mkdir -p /usr/local/tinc/lgbenet/hosts/`

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

