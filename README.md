# ubuntu_setup

---
## Unlock USB containing gpg keys
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

* Install python 

```
sudo chmod 777 python_setup.sh && ./python_setup.sh
```

* Pull repos / decrpyt archive folder

```
sudo chmod 777 pull_repos.sh && ./pull_repos.sh
```

