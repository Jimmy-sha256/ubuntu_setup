#!/bin/bash

git clone git@github.com:Jimmy-sha256/wiki.git
git clone git@github.com:Jimmy-sha256/archive.git

gpg --decrypt /home/jim/archive/archive.gpg > /home/jim/archive.tar.gz

shred -u -n 33 -z /home/jim/archive/

tar xzf archive.tar.gz

shred -u -n 33 -z archive.tar.gz
