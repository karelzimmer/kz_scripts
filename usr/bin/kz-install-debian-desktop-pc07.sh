# shellcheck shell=bash
###############################################################################
# Install file for Debian desktop on pc07.
#
# Written by Karel Zimmer <info@karelzimmer.nl>, CC0 1.0 Universal
# <https://creativecommons.org/publicdomain/zero/1.0>, 2019-2023.
###############################################################################

#1-adm
## Add user to group adm
sudo adduser "${SUDO_USER:-$USER}" adm
#2 sudo deluser ${SUDO_USER:-$USER} adm

#1-deact-eth0
## Remove activate eth0 from startup
## Message in journal: ifup -a --read-environement: Cannot find device "eth0"/ [FAILED] Raise network interfaces
sudo sed --in-place --expression='s/^auto eth0$/#auto eth0/' /etc/network/interfaces.d/setup
sudo sed --in-place --expression='s/^iface eth0 net dhcp$/#iface eth0 net dhcp/' /etc/network/interfaces.d/setup
#2 sudo sed --in-place --expression='s/^#auto eth0$/auto eth0/' /etc/network/interfaces.d/setup
#2 sudo sed --in-place --expression='s/^#iface eth0 net dhcp$/iface eth0 net dhcp/' /etc/network/interfaces.d/setup

#1 gnome-gmail
sudo apt-get install --yes gnome-gmail
#2 sudo apt-get remove --yes gnome-gmail

#1 kvm
## Images are in /var/lib/libvirt/images/
## Dpkg::Options due to interaction due to restore /etc/libvirt configuration files.
sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes --option Dpkg::Options::="--force-confdef" --option Dpkg::Options::="--force-confold" bridge-utils cpu-checker libvirt-clients libvirt-daemon-system qemu-kvm qemu-system virtinst virt-manager
sudo adduser "${SUDO_USER:-$USER}" libvirt
sudo adduser "${SUDO_USER:-$USER}" libvirt-qemu
#2 sudo apt-get remove --yes bridge-utils cpu-checker libvirt-clients libvirt-daemon-system qemu-kvm qemu-system virtinst virt-manager
#2 sudo delgroup libvirtd-dnsmasq
#2 sudo deluser ${SUDO_USER:-$USER} libvirtd
#2 sudo deluser ${SUDO_USER:-$USER} libvirtd-qemu
#2 sudo delgroup libvirtd

#1 locate
sudo apt-get install --yes mlocate
#2 sudo apt-get remove --yes mlocate

#1 signal
## Web App: n/a
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main'| sudo tee /etc/apt/sources.list.d/signal-xenial.list
wget --output-document=- 'https://updates.signal.org/desktop/apt/keys.asc' | sudo gpg --dearmor --yes --output=/usr/share/keyrings/signal-desktop-keyring.gpg
sudo apt-get update
sudo apt-get install --yes signal-desktop
#2 sudo apt-get remove --yes signal-desktop
#2 sudo rm --force /etc/apt/sources.list.d/signal-xenial.list* /usr/share/keyrings/signal-desktop-keyring.gpg*
#2 sudo apt-get update

#1 spice-vdagent
sudo apt-get install --yes spice-vdagent
#2 sudo apt-get remove --yes spice-vdagent

#1 vlc
sudo snap install vlc
#2 sudo snap remove vlc

#1 webmin
## Web App: https://localhost:10000
echo 'deb [signed-by=/usr/share/keyrings/webmin.gpg] https://download.webmin.com/download/repository sarge contrib' | sudo tee /etc/apt/sources.list.d/webmin.list
wget --output-document=- 'https://www.webmin.com/jcameron-key.asc' | sudo gpg --dearmor --yes --output=/usr/share/keyrings/webmin.gpg
sudo apt-get update
sudo apt-get install --yes webmin
#2 sudo apt-get remove --yes webmin
#2 sudo rm --force /etc/apt/sources.list.d/webmin.list* /usr/share/keyrings/webmin*
#2 sudo apt-get update
