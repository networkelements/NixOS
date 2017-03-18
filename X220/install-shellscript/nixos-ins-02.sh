#!/bin/sh
nix-env -iA nixos.emacs24-nox
nix-env -i cryptsetup f2fs-tools gptfdisk

mkdir $HOME/.emacs.d
curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/.emacs.d/init.el -o $HOME/.emacs.d/init.el

fdisk -l
lsblk -O

sgdisk -p /dev/sda
sgdisk -Z /dev/sda
sgdisk -L
sgdisk -n "1::+512M" -t 1:ef00 -c 1:"UEFI System Partition" /dev/sda
sgdisk -n "2::+1G" -t 2:8300 -c 2:"Linux boot" /dev/sda
sgdisk -n "3::" -t 3:8e00 -c 3:"Linux LVM" /dev/sda
sgdisk -p /dev/sda
lsblk -O

cryptsetup luksFormat /dev/sda3
