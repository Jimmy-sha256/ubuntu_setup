#!/bin/bash

sudo apt install vim-gtk3 -y
sudo apt install curl -y
sudo apt install keepassx -y

# import keys - need copying from airgapped storage to home dir
gpg --import /home/jim/secret.gpg
gpg --import /home/jim/public.gpg

# set the keys trust level 
echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key D5557B332830404939C27D578CEDDB5272262D4C trust

shred -u -n 33 -z /home/jim/public.gpg
shred -u -n 33 -z /home/jim/secret.gpg

# transfer config files
cp /home/jim/ubuntu_setup/config_files/gpg-agent.conf /home/jim/.gnupg 
cp /home/jim/ubuntu_setup/config_files/sshcontrol /home/jim/.gnupg 
cp /home/jim/ubuntu_setup/config_files/gtk.css /home/jim/.config/gtk-3.0

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
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']" # replace caps with ctrl
gsettings set org.gnome.desktop.session idle-delay 0 # set power saving to never
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' # set dark theme
gsettings set org.gnome.desktop.background picture-uri file:///home/jim/Pictures/background.jpg

# add apps to favourites
# gsettings get org.gnome.shell favorite-apps # list favourite apps
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'vim.desktop', 'org.gnome.Nautilus.desktop', 'keepassx.desktop']" # edit app thumbnails

dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors false # disable terminal theme colors

# copy repos script into home directory
cp /home/jim/ubuntu_setup/pull_repos.sh /home/jim/
cp /home/jim/ubuntu_setup/python_setup.sh /home/jim/

# remove setup folder
sudo rm -rf /home/jim/ubuntu_setup/

reboot

