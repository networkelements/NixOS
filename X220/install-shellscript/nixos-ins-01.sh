#!/bin/sh
loadkeys jp106

curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/install-shellscript/nixos-ins-02.sh -o nixos-ins-02.sh

chmod +x nixos-ins-02.sh

curl https://raw.githubusercontent.com/networkelements/NixOS/master/X220/install-shellscript/nixos-ins-03.sh -o nixos-ins-03.sh

chmod +x nixos-ins-03.sh

script `date '+%Y%m%d-%H:%M:%S'`.log


#sh nixos-ins-02.sh

