# install NixOS(LUKS+f2fs+KDE5)
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
1.Enter command,after LiveISO booted.  

    # systemctl start display-manager

2.Exec Konosle - terminal application, shortcut on desktop.  
3.Logging.  

    # script `date '+%Y%m%d-%H%M%S'`.log

## 2. setup keyboard

    # ls /etc/kbd/keymaps/1386/qwerty/jp106.map.gz
    # loadkeys jp106
    # setxkbmap -layout jp

## 3. install tools
    # nix-env -i emacs neovim ; nix-env -i cryptsetup ; nix-env -i f2fs-tools ; nix-env -i gptfdisk

Choose editor type 1. or 2.  

1.emacs config  
```
# mkdir $HOME/.emacs.d
# cat > $HOME/.emacs.d/init.el <<"EOF"
(require 'linum)
(global-linum-mode t)
(setq linum-format "%3d  ")
EOF
```
2.vim config  
```
# nix-env -i vim
# echo "set number" >> $HOME/.vimrc 
```


## 4. make partition
change parition like this.  
```
-----------------------------------------------
Number  Size        Code  Name
  1     512.0 MiB   EF02  EFI System partition
  2     1 GiB       8300  Linux boot
  3     <the rest>  8E00  Linux LVM
-----------------------------------------------
```
0.Check current disk status.  

    # grep -H "" /sys/block/sd*/device/model
    # fdisk -l
    # lsblk -O
 
Choose partioning type 1. or 2.  
1.Partitioning command.  
```
    # sgdisk -p /dev/nvme0n1
    # sgdisk -Z /dev/nvme0n1
    # sgdisk -L
    # sgdisk -n "1::+512M" -t 1:ef00 -c 1:"UEFI System Partition" /dev/nvme0n1
    # sgdisk -n "2::+1G" -t 2:8300 -c 2:"Linux boot" /dev/nvme0n1
    # sgdisk -n "3::" -t 3:8e00 -c 3:"Linux LVM" /dev/nvme0n1
    # sgdisk -p /dev/nvme0n1
```  
2.Paritioning REPL.  
```
    # gdisk /dev/nvme0n1
```
- `1. p` (print current partition table)
- `2. o` (create new partition table)
- `3. y` (exec)
- `4. n` (create new partition)
- `5. 1` (partition number 1)
- `6. Enter` (set starting point)
- `7. 512M` (set end point)
- `8. ef00` (partition type UEFI boot)
- `9. n` (create new partition)
- `10. 2` (partition number 2)
- `11. Enter` (set starting point)
- `12. +1G` (set end point)
- `13. 8300` (boot for LUKS)
- `14. n` (create new partition)
- `15. 3` (partition number 3)
- `16. Enter` (set starting point)
- `17. Enter` (set end point)
- `18. 8e00` (partition type  )
- `19. w` (write partition table)
- `20. y` (exec)  
```
    # gdisk /dev/nvme0n1
```
- `21. p` (print current partition table)
- `22. q` (quit)

## 5. setup LUKS 

    # cryptsetup luksFormat /dev/nvme0n1p3
- `1. YES` (type uppercase!)
- `2. ????` (Enter passphrase, unreccomend use symbol key on jp106)
- `3. ????` (Verify passphrase, type same passwords)
```    
    # cryptsetup luksOpen /dev/nvme0n1p3 enc-pv  
```
- `Enter passphrase for /dev/nvme0n1p3`
```
    # cryptsetup luksFormat /dev/nvme0n1p2  
```
- `1. YES` (type uppercase!)
- `2. ????` (Enter passphrase, unreccomend use symbol key on jp106)
- `3. ????` (Verify passphrase, type same passwords)
```    
    # cryptsetup open /dev/nvme0n1p2 cryptboot 
```
- `Enter passphrase for /dev/nvme0n1p2`
```
    # pvcreate /dev/mapper/enc-pv
    # vgcreate vg /dev/mapper/enc-pv
    # lvcreate -l '100%FREE' -n root vg
```

## 6. format filesystem


    # mkfs.fat -F32 /dev/nvme0n1p1
    # mkfs.ext2  -j -T small -L boot /dev/mapper/cryptboot  
    # mkfs.f2fs -l root /dev/vg/root  


## 7. mount

    # mount /dev/vg/root /mnt
    # mkdir /mnt/boot
    # mount /dev/mapper/cryptboot /mnt/boot
    # mkdir /mnt/boot/efi
    # mount /dev/nvme0n1p1 /mnt/boot/efi
    # lsblk
    
## 8. install NixOS

    # nixos-generate-config --root /mnt
    # cd /mnt/etc/nixos
    # mv configuration.nix _old01_configuration.nix
    # mv hardware-configuration.nix _old01_hardware-configuration.nix
    # curl https://raw.githubusercontent.com/networkelements/NixOS/master/Ryzen-7-1700/configuration.nix -o /mnt/etc/nixos/configuration.nix
    # curl https://raw.githubusercontent.com/networkelements/NixOS/master/Ryzen-7-1700/hardware-configuration.nix -o /mnt/etc/nixos/hardware-configuration.nix
    # grep "device" _old01_hardware-configuration.nix >> hardware-configuration.nix

1.Fix, sed s'/USERNAME/ほげほげ'g  configuration.nix

    # emacs -nw configuration.nix

2.Add UUID,"nixos-generate-config" and fix

    # emacs -nw hardware-configuration.nix
    # cat configuration.nix
    # cat hardware-configuration.nix
    # nixos-install
set root password
- `1. Enter new UNIX password:` (Enter passphrase)
- `2. Retype new UNIX password:` (Verify passphrase, type same passwords)
```
# reboot
```

troubleshoot
-------------
    # curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/troubleshoot.sh -o troubleshoot.sh ; chmod +x troubleshoot.sh ; sh troubleshoot.sh 

manual
-------
[boot パーティションの暗号化 (GRUB)](https://wiki.archlinuxjp.org/index.php/Dm-crypt/システム全体の暗号化#boot_.E3.83.91.E3.83.BC.E3.83.86.E3.82.A3.E3.82.B7.E3.83.A7.E3.83.B3.E3.81.AE.E6.9A.97.E5.8F.B7.E5.8C.96_.28GRUB.29)  
[Installation of NixOS with encrypted root](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)  
[Installing NixOS](https://chris-martin.org/2015/installing-nixos)  
[NixOSのインストール](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/install)  
[ヒアドキュメントの変数エスケープ](http://qiita.com/mofmofneko/items/bf003d14670644dd6197)  
[【Linux】シェルスクリプトのSMTPコマンドで終了文字列が見つからずにエラー](http://ameblo.jp/i-am-pleasure/entry-12041629875.html)  
[sgdisk(gdisk コマンドライン版) でまとめて変更する使い方](http://takuya-1st.hatenablog.jp/entry/2016/12/16/183718)
[An sgdisk Walkthrough](http://www.rodsbooks.com/gdisk/sgdisk-walkthrough.html)  
[lsblk、sgdisk、LVM 系コマンドの使用例](http://qiita.com/blp1526/items/0a88299d4bd841d01e3f)  
[arch linux で「loadkeys jp106」としてもキー](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q12163403022)
