# shellcheck shell=bash
###############################################################################
# Installatiebestand voor Ubuntu 22.04 LTS desktop.                           #
#                                                                             #
# Geschreven door Karel Zimmer <info@karelzimmer.nl>.                         #
###############################################################################

#1 apport (handmatig genereren van crashrapporten)
sudo systemctl stop apport.service
sudo systemctl disable apport.service
sudo rm --force /var/crash/*
sudo sed --in-place --expression='s/enabled=1/enabled=0/' /etc/default/apport
#2 sudo sed --in-place --expression='s/enabled=0/enabled=1/' /etc/default/apport
#2 sudo systemctl enable --now apport.service

#1 bitwarden (wachtwoordbeheer)
sudo snap install bitwarden
#2 sudo snap remove bitwarden

#1 force-x11 (Gebruik X11 i.p.v. Wayland)
## check: echo $XDG_SESSION_TYPE: x11 (i.p.v wayland)
sudo sed --in-place --expression='s/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
#2 sudo sed --in-place --expression='s/WaylandEnable=false/#WaylandEnable=false/' /etc/gdm3/custom.conf

#1 gnome-tweaks (GNOME afstellingen)
sudo apt-get install --yes gnome-tweaks
#2 sudo apt-get remove --yes gnome-tweaks

#1 google-chrome (webbrowser)
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget --no-verbose --output-document=- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor --yes --output=/usr/share/keyrings/google-chrome.gpg
sudo apt-get update
## chrome-gnome-shell; de connector die communiceert met de browserextensie om https://extensions.gnome.org te laten werken
sudo apt-get install --yes google-chrome-stable chrome-gnome-shell
## Extra nodig na installatie.
sudo rm --force /etc/apt/sources.list.d/google-chrome.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
#2 sudo apt-get remove --yes google-chrome-stable chrome-gnome-shell
#2 sudo rm --force /etc/apt/sources.list.d/google-chrome.list* /usr/share/keyrings/google-chrome.gpg*
#2 sudo rm --force /etc/apt/trusted.gpg.d/google-chrome.gpg
#2 sudo apt update

#1 language-support (taalondersteuning)
check-language-support | xargs sudo apt-get install --yes

#1 libreoffice (kantoorpakket)
sudo apt-get install --yes aspell-nl libreoffice libreoffice-help-nl libreoffice-l10n-nl
#2 sudo apt-get remove --yes libreoffice libreoffice-help-nl libreoffice-l10n-nl

#1 skype (beeldbellen)
sudo snap install --classic skype
#2 sudo snap remove skype

#1 spotify (muziekspeler)
sudo snap install spotify
#2 sudo snap remove spotify

#1 sushi (voorbeeld tonen)
## Selecteer een bestand, druk op de spatiebalk, en een preview verschijnt.
sudo apt-get install --yes gnome-sushi
#2 sudo apt-get remove --yes gnome-sushi

#1 teams (samenwerken)
## Via webbrowser: https://www.microsoft.com/nl-nl/microsoft-teams/log-in
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-teams.gpg] https://packages.microsoft.com/repos/ms-teams stable main' | sudo tee /etc/apt/sources.list.d/teams.list
wget --no-verbose --output-document=- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes --output=/usr/share/keyrings/microsoft-teams.gpg
sudo apt-get update
sudo apt-get install --yes teams
## Extra nodig na installatie.
sudo rm --force /etc/apt/sources.list.d/microsoft.gpg
## Verwijder PREVIEW in afbeelding.
sudo cp /usr/share/teams/resources/assets/MicrosoftTeams-static.png /usr/share/pixmaps/teams.png
## Verwijder Preview in starter.
sudo sed --in-place --expression='s/Microsoft Teams - Preview/Microsoft Teams/g' /usr/share/applications/teams.desktop
#2 sudo apt-get remove --yes teams
#2 sudo rm --force /etc/apt/sources.list.d/teams.list* /usr/share/keyrings/microsoft-teams.gpg*
#2 sudo rm --force /etc/apt/trusted.gpg.d/microsoft.gpg
#2 sudo apt update

#1 teamviewer (afstandsbediening)
echo 'deb [signed-by=/usr/share/keyrings/teamviewer.gpg] https://linux.teamviewer.com/deb stable main' | sudo tee /etc/apt/sources.list.d/teamviewer.list
wget --no-verbose --output-document=- https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc | sudo gpg --dearmor --yes --output=/usr/share/keyrings/teamviewer.gpg
sudo apt-get update
sudo apt-get install --yes teamviewer
## Extra nodig na installatie.
sudo apt-key del 0C1289C0 DEB49217
sudo rm --force /etc/apt/sources.list.d/teamviewer.list.dpkg-dist
#2 sudo apt-get remove --yes teamviewer
#2 sudo rm --force /etc/apt/sources.list.d/teamviewer.list* /usr/share/keyrings/teamviewer.gpg*
#2 sudo apt-key del 0C1289C0 DEB49217
#2 sudo apt update

#1 thunderbird (e-mail)
sudo apt-get install --yes xul-ext-lightning
#2 sudo apt-get remove --yes xul-ext-lightning

#1 restricted-addons (niet-vrije pakketten)
## Geen ubuntu-restricted-extras i.v.m. onbetrouwbare installatie van ttf-mscorefonts-installer, wel libavcodec-extra uit dat metapakket.
sudo apt-get install --yes ubuntu-restricted-addons libavcodec-extra
#2 sudo apt-get remove --yes ubuntu-restricted-addons libavcodec-extra
#2 sudo apt autoremove --yes

#1 wallpapers (bureabladachtergronden)
sudo apt-get install --yes ubuntu-wallpapers*
#2 sudo apt-get remove --yes ubuntu-wallpapers*

#1 zoom (samenwerken)
wget --no-verbose --output-document=/tmp/zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
sudo apt-get install --yes /tmp/zoom.deb
rm /tmp/zoom.deb
#2 sudo apt-get remove --yes zoom
