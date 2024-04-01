# shellcheck shell=bash
###############################################################################
# Set up file for Ubuntu server.
#
# Written by Karel Zimmer <info@karelzimmer.nl>.
# License CC0 1.0 <https://creativecommons.org/publicdomain/zero/1.0>.
###############################################################################

# Setup APP lynis USER
# Use Lynis (CISOfy):
# cd ~/lynis
# [sudo] ./lynis audit system
git clone https://github.com/CISOfy/lynis /home/"$USER"/lynis

# Reset APP lynis USER
rm --force --verbose --recursive --verbose /home/"$USER"/lynis


# Setup APP terminal USER *
# Search forward in history (with Ctrl-S).
sed --in-place --expression='/^stty -ixon/d' "$HOME"/.bashrc
echo 'stty -ixon  # Enable fwd search history (i-search)' >> "$HOME"/.bashrc

# Reset APP terminal USER *
sed --in-place --expression='/^stty -ixon/d' "$HOME"/.bashrc
