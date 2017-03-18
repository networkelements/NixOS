#!/bin/sh

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -l '100%FREE' -n root vg
mkfs.fat -F32 /dev/sda1
mkfs.fat -F32 /dev/sda1
mkfs.ext2 -L boot /dev/mapper/cryptboot
mkfs.f2fs -l root /dev/vg/root
   
mount /dev/vg/root /mnt
mkdir /mnt/boot
mount /dev/mapper/cryptboot /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
lsblk

nixos-generate-config --root /mnt
cd /mnt/etc/nixos
mv configuration.nix _old01_configuration.nix
mv hardware-configuration.nix _old01_hardware-configuration.nix
# curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix -o /mnt/etc/nixos/configuration.nix
# curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/hardware-configuration.nix -o /mnt/etc/nixos/hardware-configuration.nix
# grep "device" _old01_hardware-configuration.nix >> hardware-configuration.nix
emacs -nw configuration.nix
