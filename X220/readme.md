# install NixOS(LUKS+f2fs+gnome3)
## 0. setup keyboard
But,I can't change keymap...  
I guess because NixOS Live is readonly keymaps config.  

    $ ls /etc/kbd/keymaps/1386/qwerty/jp106.map.gz
    $ loadkeys jp106
    
## 1. install tools
    $ nix-env -iA nixos.emacs24-nox ; nix-env -i cryptsetup f2fs-tools wget vim gptfdisk firefox
    $ cat  <<EOF > $HOME/.emacs.d/init.el
      (require 'linum)
      (global-linum-mode t)
      (setq linum-format "%3d  ")
      `EOF'
      
## 2. make partition

change parition like this.
```
-----------------------------------------------
Number  Size        Code  Name
  1     500.0 MiB   EF02  BIOS boot partition
  2     1 GiB       EF00  EFI System Partition
  3     <the rest>  8E00  Linux LVM
-----------------------------------------------
```

```
    $ gdisk /dev/sda
```

- `1. p` (print current partition table)
- `2. o` (create new partition table)
- `3. n` (create new partition)
- `4. 1` (partition number 1)
- `5. Enter` (set starting point)
- `6. 500M` (set end point)
- `7. ef02` (partition type BIOS boot for LUKS)
- `8. n` (create new partition)
- `9. 2` (partition number 2)
- `10. Enter` (set starting point)
- `11. 1G` (set end point)
- `12. ef00` (partition type UEFI boot)
- `13. n` (create new partition)
- `14. 3` (partition number 3)
- `15. Enter` (set starting point)
- `16. Enter` (set end point)
- `17. ` (partition type  )
- `18. w` (write partition table)
- `19. y` (exec)

```
    $ gdisk /dev/sda
```

- `17. p` (print current partition table)
- `18. q` (quit)

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

[NixOSのインストール](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/install)
