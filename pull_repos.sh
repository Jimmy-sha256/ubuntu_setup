#!/bin/bash

# pull repos
git clone git@github.com:Jimmy-sha256/wiki.git
git clone git@github.com:Jimmy-sha256/archive.git
#git clone git@github.com:Jimmy-sha256/balance.git
#git clone git@github.com:Jimmy-sha256/binance.git
#git clone git@github.com:Jimmy-sha256/deribit_orders.git
git clone git@github.com:Jimmy-sha256/trade_calc.git

####

#cd /home/jim/balance/ && virtualenv --python=/usr/bin/python3.10 venv && source venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..
#cd /home/jim/deribit_orders/ && virtualenv --python=/usr/bin/python3.10 venv && source venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..
#cd /home/jim/binance/ && virtualenv --python=/usr/bin/python3.10 venv && source venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..


#chmod 777 /home/jim/balance/balance.sh
#chmod 777 /home/jim/binance_orders/binance.sh
#chmod 777 /home/jim/deribit_orders/deribit_order.sh

# decrypt the .gpg
gpg --decrypt /home/jim/archive/archive.gpg > /home/jim/archive.tar.gz

# remove archive repo
rm -rf /home/jim/archive/

# extract archive
tar -xzvf archive.tar.gz

# remove archive.tar.gz
shred -u -n 33 -z archive.tar.gz
