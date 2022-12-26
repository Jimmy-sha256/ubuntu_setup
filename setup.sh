#!/bin/bash

sudo apt install vim-gtk3 -y
sudo apt install curl -y
sudo apt install keepassx -y
sudo apt install fzf -y
sudo apt install ripgrep -y

# python
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install virtualenv -y
sudo apt install ipython3 -y

# import keys - need copying from airgapped storage to home dir
gpg --import /media/jim/GPG_SUB_KEYS/secret.gpg
gpg --import /media/jim/GPG_SUB_KEYS/public.gpg

# set the keys trust level 
echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key D5557B332830404939C27D578CEDDB5272262D4C trust

#shred -u -n 33 -z /home/jim/public.gpg
#shred -u -n 33 -z /home/jim/secret.gpg

# transfer config files
cp /home/jim/ubuntu_setup/config_files/gpg-agent.conf /home/jim/.gnupg 
cp /home/jim/ubuntu_setup/config_files/sshcontrol /home/jim/.gnupg 
cp /home/jim/ubuntu_setup/config_files/gtk.css /home/jim/.config/gtk-3.0
cp /home/jim/ubuntu_setup/config_files/dconf-backup.dconf /home/jim/dconf-backup.dconf

# transfer dot files
cp /home/jim/ubuntu_setup/dot_files/.bash_profile /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.bashrc /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.gitconfig /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.gitignore_global /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.inputrc /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.profile /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.tmux.conf /home/jim/
cp /home/jim/ubuntu_setup/dot_files/.vimrc /home/jim/
cp /home/jim/ubuntu_setup/background.jpg /home/jim/Pictures/

# dock settings
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 35
#gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']" # replace caps with ctrl
gsettings set org.gnome.desktop.session idle-delay 0 # set power saving to never
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' # set dark theme
gsettings set org.gnome.desktop.background picture-uri file:///home/jim/Pictures/background.jpg

# add apps to favourites

# gsettings get org.gnome.shell favorite-apps # list favourite apps
gsettings set org.gnome.shell favorite-apps "['firefox_firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'keepassx.desktop']" # edit app thumbnails

# load dconf file containing reasigned keyboard shortcuts
#sudo dconf load / < /home/jim/ubuntu_setup/config_files/dconf_backup.txt

# pull repos
#git clone git@github.com:Jimmy-sha256/encrypted_archive.git
#git clone git@github.com:Jimmy-sha256/trade_calc.git

# decrypt the .gpg
#gpg --decrypt /home/jim/encrypted_archive/archive.gpg > /home/jim/archive.tar.gz

# extract archive
#tar -xzvf archive.tar.gz

# remove archive.tar.gz
#shred -u -n 33 -z archive.tar.gz


# remove setup folder
#sudo rm -rf /home/jim/ubuntu_setup/

reboot

