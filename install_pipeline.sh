#!/bin/bash

# on arch
sh arch/install_arch.sh
sh install_linux.sh
sh install_stow.sh
sh install_cli.sh
sh install_nvim.sh
sh install_theme.sh
sh arch/install_pulse.sh

# extra

sudo gpasswd -a $USER input
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh

echo "[redshift]
allowed=true
systemjkhjkjjk=false
users=" | sudo tee -a /etc/geoclue/geoclue.conf
