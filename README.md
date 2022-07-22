# ubuntu_setup

* Initial update

```
sudo apt update && sudo apt upgrade -y && sudo apt install git

```

* Initial setup copy public.gpg and secret.gpg from airgapped secure storage to /home/jim/ before executing code

```
sudo git clone https://github.com/Jimmy-sha256/ubuntu_setup.git
```
```
cd ubuntu_setup && sudo chmod 777 setup.sh && ./setup.sh
```

* Install python 

```
sudo chmod 777 python_setup.sh && ./python_setup.sh
```


* Pull repos / decrpyt archive folder

```
sudo chmod 777 pull_repos.sh && ./pull_repos.sh
```

