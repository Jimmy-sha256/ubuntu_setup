### Unlock USB Containing GPG Keys
---


* Initial update

```
sudo apt update && sudo apt upgrade -y && sudo apt install git
```

* Pull ubuntu_setup repositroy

```
sudo git clone https://github.com/Jimmy-sha256/ubuntu_setup.git
```

* Navigate to ubuntu_setup directory

```
cd ubuntu_setup && sudo chmod 777 setup.sh && ./setup.sh
```

* Pull Repositories

```
sudo chmod 777 pull_repos.sh && ./pull_repos.sh
```
