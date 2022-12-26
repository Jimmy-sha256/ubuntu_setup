#!/bin/bash

# pull repos
git clone git@github.com:Jimmy-sha256/encrypted_archive.git
git clone git@github.com:Jimmy-sha256/trade_calc.git

#git clone git@github.com:Jimmy-sha256/balance.git
#chmod 777 /home/jim/balance/balance.sh

# decrypt the .gpg
gpg --decrypt /home/jim/archive/archive.gpg > /home/jim/archive.tar.gz

# remove archive repo
rm -rf /home/jim/archive/

# extract archive
tar -xzvf archive.tar.gz

# remove archive.tar.gz
shred -u -n 33 -z archive.tar.gz
