#!/bin/sh
#script `date '+%Y%m%d-%H:%M:%S'`.log

nix-env -iA nixos.emacs24-nox ; nix-env -i cryptsetup f2fs-tools gptfdisk

# echo "set number" >> $HOME/.vimrc 

mkdir $HOME/.emacs.d
cat > $HOME/.emacs.d/init.el <<"EOF"
(require 'linum)
(global-linum-mode t)
(setq linum-format "%3d  ")
EOF




cryptsetup luksOpen /dev/sda3 enc-pv

#lvchange -a y /dev/vg/swap

lvchange -a y /dev/vg/root
mount /dev/vg/root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

#swapon /dev/vg/swap

#cp /mnt/etc/wpa_supplicant.conf /etc
#systemctl start wpa_supplicant

cd /mnt/etc/nixos
#curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix -o /mnt/etc/nixos/configuration.nix
#curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/hardware-configuration.nix -o /mnt/etc/nixos/hardware-configuration.nix
