# install tools

1. nix-env -i cryptsetup f2fs-tools fish gptfdisk firefox git
2. gdisk
  1) o
  2) n
  3) 1
  4) Enter
  5) 1G
  6) Enter
  7) n
  8) 2
  9) Enter
  10) 235G
  11) Enter
  12) n
  13) 3
  14) Enter
  15) Enter
  16) 8200
  17) w   --> yes
  18) p
  19) q

3.
mkfs.f2fs -l boot /dev/sda1
mkfs.f2fs -l cryptroot /dev/sda2
mkswap /dev/sda3




