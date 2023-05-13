# shellcheck shell=bash
###############################################################################
# Install file for Ubuntu desktop on pc01.
#
# Written by Karel Zimmer <info@karelzimmer.nl>, CC0 1.0 Universal
# <https://creativecommons.org/publicdomain/zero/1.0>, 2009-2023.
###############################################################################

#1-bluetooth
## Disable internal bluetooth adapter
echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="413c", ATTRS{idProduct}=="8187", ATTR{authorized}="0"' | sudo tee /etc/udev/rules.d/81-bluetooth-hci.rules
#2 sudo rm --force /etc/udev/rules.d/81-bluetooth-hci.rules

#1-gast
sudo useradd --create-home --shell /bin/bash --comment 'Gast' gast || true
sudo passwd --delete gast
#2 sudo userdel --remove gast

#1 gnome-gmail
sudo apt-get install --yes gnome-gmail
#2 sudo apt-get remove --yes gnome-gmail

#1-hosts
sudo sed --in-place --expression='/^192.168.1.83/d' /etc/hosts
sudo sed --in-place --expression='/^192.168.1.64/d' /etc/hosts
echo '192.168.1.83 pc06' | sudo tee --append /etc/hosts
echo '192.168.1.64 pc01' | sudo tee --append /etc/hosts
#2 sudo sed --in-place --expression='/^192.168.1.83/d' /etc/hosts
#2 sudo sed --in-place --expression='/^192.168.1.64/d' /etc/hosts

#1 ssh
sudo apt-get install --yes ssh
sudo sed --in-place --expression='s/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
## Check op remote root-toegang.
grep --quiet --regexp='PermitRootLogin no' /etc/ssh/sshd_config
sudo systemctl restart ssh.service
#2 sudo sed --in-place --expression='s/PermitRootLogin no/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
#2 sudo apt-get remove --yes ssh

#1 ufw
sudo apt-get install --yes gufw
sudo ufw allow ssh
sudo ufw enable
#2 sudo ufw disable
