# install NixOS(LUKS+f2fs+gnome3)
## 0. 1st step
Download from [NixOS official site](http://nixos.org/nixos/download.html)  

    
    > aria2c https://d3g5gsiof5omrk.cloudfront.net/nixos/16.09/nixos-16.09.1829.c88e67d/nixos-graphical-16.09.1829.c88e67d-x86_64-linux.iso  
    > sudo parted /dev/sdg
    [sudo] ほげ のパスワード: 
    GNU Parted 3.2
    /dev/sdg を使用
    GNU Parted へようこそ！ コマンド一覧を見るには 'help' と入力してください。
    (parted) p                                                                    
    モデル: BUFFALO USB Flash Disk (scsi)
    ディスク /dev/sdg: 8020MB
    セクタサイズ (論理/物理): 512B/512B
    パーティションテーブル: msdos
    ディスクフラグ: 

    番号  開始    終了    サイズ  タイプ   ファイルシステム  フラグ
     1    1049kB  8020MB  8018MB  primary  fat32

    (parted) q 
    > sudo dd bs=4M if=nixos-graphical-16.09.1829.c88e67d-x86_64-linux.iso of=/dev/sdg

## 1. Boot from USB
    # systemctl start display-manager
Exec Konosle - terminal application, shortcut on desktop.

## 1. setup keyboard
But,I can't change keymap...  
I guess because NixOS Live is readonly keymaps config.  

    # ls /etc/kbd/keymaps/1386/qwerty/jp106.map.gz
    # loadkeys jp106
    # sed s'/us/jp106/'g /etc/vconsole.conf

\# sed s'/us/jp106/'g /etc/vconsole.conf  
is no ERROR, but It's no changes.  
Same changes in nano editor, nano said  
"Error writing /etc/vconsole.conf: Read-only file system"  


## 2. install tools
    # nix-env -iA nixos.emacs24-nox ; nix-env -i cryptsetup f2fs-tools wget vim gptfdisk firefox

Choose editor type 1. or 2.  
1.vim config  
```
# echo "set number" >> $HOME/.vimrc 
```
2.emacs config  
```
# mkdir $HOME/.emacs.d
# cat > $HOME/.emacs.d/init.el <<"EOF"
(require 'linum)
(global-linum-mode t)
(setq linum-format "%3d  ")
EOF
```

## 3. make partition

change parition like this.
```
-----------------------------------------------
Number  Size        Code  Name
  1     500.0 MiB   EF02  BIOS boot partition
  2     1 GiB       EF00  EFI System Partition
  3     <the rest>  8E00  Linux LVM
-----------------------------------------------
```
Choose partioning type 1. or 2.  
1.Partitioning command.  

```
    # sgdisk -p
    # sgdisk -Z /dev/sda
    # sgdisk -L
    # sgdisk -n "${1}:${0}:${500M}" -t 1:ef02 -c 1:"BIOS boot partition" /dev/sda
    # sgdisk -n "${2}:${0}:${+1G}" -t 2:ef00 -c 2:"UEFI System Partition" /dev/sda
    # sgdisk -n "${3}:${0}:${0}" -t 3:8e00 -c 3:"Linux LVM" /dev/sda
```  
2.Paritioning REPL.  

```
    # gdisk /dev/sda
```

- `1. p` (print current partition table)
- `2. o` (create new partition table)
- `3. y` (exec)
- `4. n` (create new partition)
- `5. 1` (partition number 1)
- `6. Enter` (set starting point)
- `7. 500M` (set end point)
- `8. ef02` (partition type BIOS boot for LUKS)
- `9. n` (create new partition)
- `10. 2` (partition number 2)
- `11. Enter` (set starting point)
- `12. +1G` (set end point)
- `13. ef00` (partition type UEFI boot)
- `14. n` (create new partition)
- `15. 3` (partition number 3)
- `16. Enter` (set starting point)
- `17. Enter` (set end point)
- `18. 8e00` (partition type  )
- `19. w` (write partition table)
- `20. y` (exec)

```
    # gdisk /dev/sda
```

- `21. p` (print current partition table)
- `22. q` (quit)

## 4. setup LUKS 
    # cryptsetup luksFormat /dev/sda3
    
- `1. YES` (type uppercase!)
- `2. ????` (Enter passphrase, unreccomend use symbol key on jp106)
- `3. ????` (Verify passphrase, type same passwords)

```
    # cryptsetup luksOpen /dev/sda3 enc-pv
    # pvcreate /dev/mapper/enc-pv
    # vgcreate vg /dev/mapper/enc-pv
    # lvcreate -l '100%FREE' -n root vg
```

## 5. format filesystem
    # mkfs.vfat /dev/sda2
    # mkfs.f2fs -l root /dev/vg/root

## 6. mount
    # mount /dev/vg/root /mnt
    # mkdir /mnt/boot
    # mount /dev/sda1 /mnt/boot

## 7. install NixOS
    # nixos-generate-config --root /mnt
    # cd /mnt/etc/nixos
    # mv configuration.nix _old01_configuration.nix
    # mv hardware-configuration.nix _old01_hardware-configuration.nix
    # wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/configuration.nix
    # wget https://raw.githubusercontent.com/networkelements/NixOS/master/X220/hardware-configuration.nix
    # grep "device" _old01_hardware-configuration.nix >> hardware-configuration.nix
    # emacs -nw configuration.nix
    # emacs -nw hardware-configuration.nix
    # cat configuration.nix
    # nixos-install
set root password
```
# reboot
```

manual
======
[Installation of NixOS with encrypted root](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)  
[Installing NixOS](https://chris-martin.org/2015/installing-nixos)  
[NixOSのインストール](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/install)  
[ヒアドキュメントの変数エスケープ](http://qiita.com/mofmofneko/items/bf003d14670644dd6197)  
[【Linux】シェルスクリプトのSMTPコマンドで終了文字列が見つからずにエラー](http://ameblo.jp/i-am-pleasure/entry-12041629875.html)  
[sgdisk(gdisk コマンドライン版) でまとめて変更する使い方](http://takuya-1st.hatenablog.jp/entry/2016/12/16/183718)
[An sgdisk Walkthrough](http://www.rodsbooks.com/gdisk/sgdisk-walkthrough.html)
[lsblk、sgdisk、LVM 系コマンドの使用例](http://qiita.com/blp1526/items/0a88299d4bd841d01e3f)
