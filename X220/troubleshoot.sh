#!/bin/sh
script `date '+%Y%m%d-%H:%M:%S'`.log

nix-env -i cryptsetup f2fs-tools wget vim gptfdisk
echo "set number" >> $HOME/.vimrc 
cryptsetup luksOpen /dev/sda3 enc-pv

#lvchange -a y /dev/vg/swap

lvchange -a y /dev/vg/root
mount /dev/vg/root /mnt
mount /dev/sda1 /mnt/boot

#swapon /dev/vg/swap

#cp /mnt/etc/wpa_supplicant.conf /etc
#systemctl start wpa_supplicant

cd /mnt/etc/nixos
wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix -O /mnt/etc/nixos/configuration.nix
wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/hardware-configuration.nix -O /mnt/etc/nixos/hardware-configuration.nix
