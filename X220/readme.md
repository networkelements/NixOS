# install NixOS(LUKS+f2fs+gnome3)
## 1. install tools
    $ nix-env -i cryptsetup f2fs-tools fish emacs vim gptfdisk firefox  

## 2. make partition
    $ gdisk /dev/sda
    1. p
    2. o
    3. n
    4. 1
    5. 500M
    6. 1G
    7. L
    8. Enter
    9. ef00
    10. n
    11. 2
    12. Enter
    13. Enter
    14. Enter (default 8300)
    15. w
    16. y
    $ gdisk /dev/sda
    17. p
    18.p

## 3. setup LUKS 
    $ cryptsetup luksFormat /dev/sda2
    - `YES` (uppercase!)
    - `Enter passphrase` 
    - `Verify passphrase`
    $ cryptsetup luksOpen /dev/sda2 enc-pv
    $ pvcreate /dev/mapper/enc-pv
    $ vgcreate vg /dev/mapper/enc-pv
    $ lvcreate -l '100%FREE' -n root vg

## 4. format filesystem
    $ mkfs.vfat /dev/sda1
    $ mkfs.f2fs -l root /dev/vg/root

## 5. mount
    $ mount /dev/vg/root /mnt
    $ mkdir /mnt/boot
    $ mount /dev/sda1 /mnt/boot

## 6. install NixOS
    $ cd /mnt/etc/nixos
    $ mv configuration.nix _old01_configuration.nix
    $ mv hardware-configuration.nix _old01_hardware-configuration.nix
    $ wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix
    $ wget https://gist.githubusercontent.com/networkelements/1510f091fc401b5f80d4aa94c03c1685/raw/bea314b1cf1bced7cb288237ad494c4b0fd44d70/hardware-configuration.nix
    $ emacs -nw configuration.nix
    $ emacs -nw hardware-configuration.nix
    $ cat configuration.nix
    $ cat hardware-configuration.nix
    $ nixos-install
    $ reboot

manual
-------
[Installation of NixOS with encrypted root](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)
