#!/bin/sh

# PinePhone-Pro Post Installation Setup Script
# Author: James Goodwin Email: SuperPhenotype@gmail.com
# Parts Taken from elsewhere.

# A script to change the current username
# https://wiki.mobian-project.org/doku.php?id=tweaks#changing-the-default-username-from-mobian
if [ "$(id -u)" != "0" ]; then echo "This script must be run as root" 1>&2 exit 1 fi

set -e

cd /

# Get current username
printf "\nType the current username:\n"
read old

# Set desired username
printf "\nType the desired username:\n"
read new

# Home paths
ohp="home/$old"
nhp="home/$new"

# Change username
printf "\nChanging username\n"

for file in group gshadow passwd shadow subgid subuid
do
    sed -i "s/$old/$new/g" /etc/$file*
done

# Rename home folder
mv /$ohp /$nhp

# Fix path references in /home for new user
printf "\nAdjusting paths in home directory\n"

grep -rl "$ohp" /$nhp | xargs sed -i "s+$ohp+$nhp+g"

# Set user info
echo
chfn $new
sync

reboot


