#!/bin/sh
# Copyright (c) 2025 LaVitae
# GNU General Public License v3.0 (see https://www.gnu.org/licenses/gpl-3.0.txt)

# variables
GREETINGS="Hi! This script will copy the mpv.conf into directories for Jellyfin Media Player to get SVP to work."
CONFIRMATION="Would you like to continue the process? Please type 1 or 2 respectively ..."
CONFIRMATION_USERNAME="Please enter your user name as listed in directories. It is crucial that it is correct!"
USER=""
COPY="Copying mpv.conf to directories..."
DELETE="Deleting mpv.conf template as not needed anymore..."
ALL_DONE="Everything is done!"
EXITING_NOW="Exiting now!"

# main script
echo $CONFIRMATION
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) echo $EXITING_NOW; sleep 1; exit;;
    esac
done

echo $CONFIRMATION_USERNAME
read USER

sleep 1
echo $COPY
cp mpv.conf /home/$USER/.local/share/jellyfinmediaplayer/mpv.conf
cp mpv.conf /home/$USER/.local/share/Jellyfin\ Media\ Player/mpv.conf
sleep 1
echo $DELETE
rm -r mpv.conf
sleep 1
echo $ALL_DONE
sleep 1
echo $EXITING_NOW
sleep 1
exit
