```
loadkeys jp106

nix-env -i gptfdisk firefox f2fs-tools fish cryptsetup emacs24-nox
fish
script -a install.log
gdisk /dev/sda




mkfs.f2fs -l boot /dev/sda1
mkfs.f2fs -l nixos /dev/sda2
mkswap -L swap /dev/sda3
swapon /dev/sda3
mount /dev/disk/by-label/nixos /mnt
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix.bk
which fish
curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix -o /mnt/etc/nixos/configuration.nix
sdiff /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix.bk
nixos-install
passwd
reboot

passwd murasame
```
