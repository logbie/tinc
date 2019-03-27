Logbie tinc
------------
***
First we need to install the prereqs to build the tinc pakage.
### ubuntu
`sudo apt install build-essential automake libssl-dev liblzo2-dev libbz2-dev zlib1g-dev git`

Next, create a `tinc` user and give them sudo ablity

>`adduser tinc`
>`adduser tinc sudo`

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
3) `sudo make install`
