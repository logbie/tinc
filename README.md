Logbie tinc
------------
***
First we need to install the prereqs to build the tinc pakage.
### ubuntu
`sudo apt install build-essential automake libssl-dev liblzo2-dev libbz2-dev zlib1g-dev git`

Next, create a `tinc` user and give them sudo ablity

Now, we need to clone the git repository to our local machine

`git clone git@github.com:logbie/tinc.git`
(you will need to deploy key)

next we need to Build the package

1) `sudo sh ./configure`
2) `sudo make`
3) `sudo make install`
