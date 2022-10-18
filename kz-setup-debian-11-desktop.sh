# shellcheck shell=bash
###############################################################################
# Instelbestand voor Debian 11 LTS desktop.
#
# Geschreven in 2021 door Karel Zimmer <info@karelzimmer.nl>, Creative Commons
# Publiek Domein Verklaring <http://creativecommons.org/publicdomain/zero/1.0>.
###############################################################################

#1 bitwarden (wachtwoordbeheer)
kz-gset --addfavaft=bitwarden_bitwarden
#2 kz-gset --delfav=bitwarden_bitwarden

#1 citrix (telewerken)
## Aka Citrix Workspace app, Citrix Receiver, ICA Client.
xdg-mime default wfica.desktop application/x-ica

#1 google-chrome (webbrowser)
kz-gset --addfavbef=google-chrome
#2 kz-gset --delfav=google-chrome

#1-install-debian (installatie Debian starten)
kz-gset --delfav=install-debian
#2 kz-gset --addfavbef=install-debian

#1 snap (snap verbergen in Persoonlijke map)
printf '%s\n' 'snap' > "$HOME"/.hidden
#2 rm --force "$HOME"/.hidden

#1 skype (beeldbellen)
kz-gset --addfavaft=skype_skypeforlinux
#2 kz-gset --delfav=skype_skypeforlinux

#1 spotify (muziekspeler)
kz-gset --addfavaft=spotify_spotify
#2 kz-gset --delfav=spotify_spotify

#1 teams (samenwerken)
kz-gset --addfavaft=teams # Old package.
kz-gset --addfavaft=teams_teams
#2 kz-gset --delfav=teams # Old package.
#2 kz-gset --delfav=teams_teams

#1 zoom (samenwerken)
kz-gset --delfav=Zoom # Old package.
kz-gset --addfavaft=zoom-client_zoom-client
#2 kz-gset --delfav=Zoom # Old package.
#2 kz-gset --delfav=zoom-client_zoom-client

#1 gnome (bureaubladomgeving)
kz-gset --addappfolder --folder='KZ Scripts'
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 900
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'large'
gsettings set org.gnome.nautilus.preferences click-policy 'single'
gsettings set org.gnome.settings-daemon.peripherals.touchscreen orientation-lock true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
#2 kz-gset --delappfolder --folder='KZ Scripts'
#2 gnome-extensions disable dash-to-dock@micxgx.gmail.com
#2 gsettings reset org.gnome.app-folders folder-children
#2 gsettings reset org.gnome.calendar show-weekdate
#2 gsettings reset org.gnome.desktop.interface clock-show-date
#2 gsettings reset org.gnome.desktop.interface clock-show-weekday
#2 gsettings reset org.gnome.desktop.interface show-battery-percentage
#2 gsettings reset org.gnome.nautilus.icon-view default-zoom-level
#2 gsettings reset org.gnome.nautilus.preferences click-policy
#2 gsettings reset org.gnome.peripherals.touchpad tap-to-click
#2 gsettings reset org.gnome.screensaver lock-enabled
#2 gsettings reset org.gnome.settings-daemon.peripherals.touchscreen orientation-lock
#2 gsettings reset org.gnome.settings-daemon.plugins.color night-light-enabled
#2 gsettings reset org.gnome.settings-daemon.plugins.media-keys max-screencast-length
#2 gsettings reset org.gnome.settings-daemon.plugins.power idle-dim
#2 gsettings reset org.gnome.settings-daemon.plugins.power power-button-action
#2 gsettings reset org.gnome.shell.extensions.dash-to-dock apply-custom-theme
#2 gsettings reset org.gnome.shell.extensions.dash-to-dock click-action
#2 gsettings reset org.gnome.shell.extensions.dash-to-dock dash-max-icon-size
#2 gsettings reset org.gnome.shell.extensions.dash-to-dock dock-fixed true
#2 gsettings reset org.gnome.shell.extensions.dash-to-dock extend-height true
#2 gsettings reset org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
#2 gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed
