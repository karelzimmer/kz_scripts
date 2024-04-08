# shellcheck shell=bash
###############################################################################
# SPDX-FileComment: Set up file for Debian server
#
# SPDX-FileCopyrightText: Karel Zimmer <info@karelzimmer.nl>
# SPDX-License-Identifier: CC0-1.0
###############################################################################

# Setup APP lynis USER
git clone https://github.com/CISOfy/lynis /home/"$USER"/lynis || true
: # Use Lynis (CISOfy):
: # cd ~/lynis
: # [sudo] ./lynis audit system

# Reset APP lynis USER
rm --force --verbose --recursive --verbose /home/"$USER"/lynis


# Setup APP terminal USER *
: # # Turn on aliases.
sed --in-place --expression='s/#alias/alias/g' "$HOME"/.bashrc
sed --in-place --expression='/^stty -ixon/d' "$HOME"/.bashrc
: # Enable search forward in history (with Ctrl-S).
echo 'stty -ixon  # Enable fwd search history (i-search)' >> "$HOME"/.bashrc

# Reset APP terminal USER *
sed --in-place --expression='s/alias/#alias/g' "$HOME"/.bashrc
sed --in-place --expression='/^stty -ixon/d' "$HOME"/.bashrc
