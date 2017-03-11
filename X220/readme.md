# install NixOS(LUKS+f2fs+gnome3)
## 1. install tools
    $ nix-env -iA nixos.emacs24-nox ; nix-env -i cryptsetup f2fs-tools wget vim gptfdisk firefox  

## 2. make partition

change parition like this.
```
-----------------------------------------------
Number  Size        Code  Name
  1     500.0 MiB  EF02  BIOS boot partition
  2     1 GiB   EF00  EFI System Partition
  3     <the rest>  8E00  Linux LVM
-----------------------------------------------
```

```
    $ gdisk /dev/sda
```

- `1. p` ()
- `2. o` ()
- `3. n` ()
- `4. 1` ()
- `5. Enter` ()
- `6. 500M` ()
- `7. ef02` ()
- `8. n` ()
- `9. 2` ()
- `10. Enter` ()
- `11. 1G` ()
- `12. ef00` ()
- `13. n` ()
- `14. 2` ()
- `15. Enter` ()
- `16. Enter` ()
- `17. Enter` (default 8300)
- `18. w` ()
- `19. y` ()

```
    $ gdisk /dev/sda
```

- `17. p` ()
- `18. q` ()

## 3. setup LUKS 
    $ cryptsetup luksFormat /dev/sda2
    
- `YES` (type uppercase!)
- `Enter passphrase` (unreccomend use symbol key on jp106)
- `Verify passphrase` (type same passwords)

```
    $ cryptsetup luksOpen /dev/sda2 enc-pv
    $ pvcreate /dev/mapper/enc-pv
    $ vgcreate vg /dev/mapper/enc-pv
    $ lvcreate -l '100%FREE' -n root vg
```

## 4. format filesystem
    $ mkfs.vfat /dev/sda1
    $ mkfs.f2fs -l root /dev/vg/root

## 5. mount
    $ mount /dev/vg/root /mnt
    $ mkdir /mnt/boot
    $ mount /dev/sda1 /mnt/boot

## 6. install NixOS
    $ nixos-generate-config --root /mnt
    $ cd /mnt/etc/nixos
    $ mv configuration.nix _old01_configuration.nix
    $ mv hardware-configuration.nix _old01_hardware-configuration.nix
    $ wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix
    $ wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/hardware-configuration.nix
    $ grep "device" _old01_hardware-configuration.nix >> hardware-configuration.nix
    $ emacs -nw configuration.nix
    $ emacs -nw hardware-configuration.nix
    $ cat configuration.nix
    $ nixos-install
    $ reboot

manual
======
[Installation of NixOS with encrypted root](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)

[Installing NixOS](https://chris-martin.org/2015/installing-nixos)
