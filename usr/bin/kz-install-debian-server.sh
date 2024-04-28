# shellcheck shell=bash
###############################################################################
# SPDX-FileComment: Install file for Debian server
#
# SPDX-FileCopyrightText: Karel Zimmer <info@karelzimmer.nl>
# SPDX-License-Identifier: CC0-1.0
###############################################################################

# Install APP 00-users HOST *
: # Enable access to system monitoring tasks like read many log files in /var/log.
sudo usermod --append --groups adm "${SUDO_USER:-$USER}"

# Remove APP 00-users HOST *
sudo deluser "${SUDO_USER:-$USER}" adm


# Install APP 99-fwupd HOST -nohost
: # Disable the Firmware update daemon
sudo systemctl stop fwupd.service
sudo systemctl disable fwupd.service
sudo systemctl mask fwupd.service

# Remove APP 99-fwupd HOST -nohost
: # Enable the Firmware update daemon
systemctl unmask fwupd.service
sudo systemctl enable fwupd.service
sudo systemctl start fwupd.service


# Install APP ansible HOST *
sudo apt-get install --yes ansible

# Remove APP ansible HOST *
sudo apt-get remove --yes ansible


# Install APP locate HOST *
sudo apt-get install --yes mlocate

# Remove APP locate HOST *
sudo apt-get remove --yes mlocate


# Install APP repair-ntfs HOST -nohost
sudo apt-get install --yes ntfs-3g
: # Usage:
: # $ findmnt
: #   TARGET          SOURCE    FSTYPE OPTIONS
: #   /media/...      /dev/sdb2 ntfs3  rw,nosuid,nodev,relatime,uid=...
: # $ sudo ntfsfix /dev/sdb2

# Remove APP repair-ntfs HOST -nohost
sudo apt-get remove --yes ntfs-3g


# Install APP ssh HOST *
sudo apt-get install --yes ssh
sudo sed --in-place --expression='s/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
: # Check for remote root access.
grep --quiet --regexp='PermitRootLogin no' /etc/ssh/sshd_config
sudo systemctl restart ssh.service

# Remove APP ssh HOST *
sudo sed --in-place --expression='s/PermitRootLogin no/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sudo sed --in-place --expression='s/PermitRootLogin no/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sudo apt-get remove --yes ssh


# Install APP ufw HOST *
sudo apt-get install --yes ufw
sudo ufw allow ssh
sudo ufw enable

# Remove APP ufw HOST *
sudo ufw disable
sudo apt-get remove --yes ufw
