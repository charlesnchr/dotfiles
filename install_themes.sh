#!/bin/bash

# KDE theme
git clone https://github.com/tonyfettes/materia-nord-kvantum.git
cd materia-nord-kvantum
sudo mv Kvantum/MateriaNordDark /usr/share/Kvantum

# GTK theme
# https://github.com/EliverLara/Nordic
# https://www.gnome-look.org/p/1267246/
wget https://github.com/EliverLara/Nordic/releases/download/v2.1.0/Nordic-darker-v40.tar.xz
tar xvf Nordic-darker-v40.tar.xz
sudo mv Nordic-darker-v40 /usr/share/themes
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
