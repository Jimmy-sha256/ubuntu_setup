#!/bin/bash

# pull repos
git clone git@github.com:Jimmy-sha256/encrypted_archive.git
git clone git@github.com:Jimmy-sha256/trade_calc.git

# decrypt the .gpg
gpg --decrypt /home/jim/encrypted_archive/archive.gpg > /home/jim/archive.tar.gz

# extract archive
tar -xzvf archive.tar.gz

# remove archive.tar.gz
shred -u -n 33 -z archive.tar.gz
