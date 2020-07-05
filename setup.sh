sudo apt install git -y
sudo apt install vim-gtk -y
sudo apt install curl -y

# import keys
gpg --import /home/jim/secret.gpg
gpg --import /home/jim/public.gpg

# set the keys trust level 
echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key D5557B332830404939C27D578CEDDB5272262D4C trust

shred -u -n 33 -z public.gpg
shred -u -n 33 -z secret.gpg


# transfer config files
cp /home/jim/ubunt_setup/config_files/gpg-agent.conf /home/jim/.gnupg 
cp /home/jim/ubunt_setup/config_files/sshcontrol /home/jim/.gnupg 
cp /home/jim/ubunt_setup/config_files/gtk.css /home/jim/.config/gtk-3.0

# transfer dot files
cp /home/jim/ubunt_setup/dot_files/.bash_profile /home/jim/
cp /home/jim/ubunt_setup/dot_files/.bashrc /home/jim/
cp /home/jim/ubunt_setup/dot_files/.gitconfig /home/jim/
cp /home/jim/ubunt_setup/dot_files/.gitignore_global /home/jim/
cp /home/jim/ubunt_setup/dot_files/.inputrc /home/jim/
cp /home/jim/ubunt_setup/dot_files/.profile /home/jim/
cp /home/jim/ubunt_setup/dot_files/.tmux.conf /home/jim/
cp /home/jim/ubunt_setup/dot_files/.vimrc /home/jim/

# dock settings
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 35

gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']" # replace caps with ctrl