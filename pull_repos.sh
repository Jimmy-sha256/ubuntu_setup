#!/bin/bash

# pull repos
git clone git@github.com:Jimmy-sha256/wiki.git
git clone git@github.com:Jimmy-sha256/archive.git
git clone git@github.com:Jimmy-sha256/orders.git

# create venv for orders

virtualenv --python=/usr/bin/python3.7 /home/jim/orders/venv

# decrypt the .gpg
gpg --decrypt /home/jim/archive/archive.gpg > /home/jim/archive.tar.gz

# remove archive repo
rm -rf /home/jim/archive/

# extract archive
tar -xzvf archive.tar.gz

# remove archive.tar.gz
shred -u -n 33 -z archive.tar.gz
