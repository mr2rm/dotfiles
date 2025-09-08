#!/bin/bash

set -eu

printf "Empty trash...\n"
sudo rm -rf ~/.local/share/Trash/*

printf "\nClean up packages...\n"
sudo apt-get autoremove --purge

printf "\nClean up APT cache...\n"
sudo apt-get clean

printf "\nClear systemd journal logs...\n"
sudo journalctl --vacuum-time=3d

# WARNING: Close all snaps before running this
printf "\Remove old revisions of snaps...\n"
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

printf "\Remove dangling docker images...\n"
docker system prune -f
