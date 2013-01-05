 #This is a generated file.  Do not modify!
 # Make changes to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  require = [
    <nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.initrd.kernelModules = [ "ehci_hcd" "ahci" "usbhid" "btrfs" "ext4" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  nix.maxJobs = 4;

  boot.loader.grub = {
  version = 2;
  enable = true;
	device = "/dev/sda";
	};

  fileSystems =
	[{ mountPoint = "/";
	   device = "/dev/disk/by-label/nixos";
	   fsType = "btrfs";
	 }
	];

  i18n = {
	consoleKeyMap = "jp106";
	defaultLocale = "ja_JP.UTF-8";
	};

  time = {
	timeZone = "Asia/Tokyo";
	};

  services.xserver = {
	enable = true;
	layout = "jp";
	xkbModel = "jp106";
	desktopManager.kde4.enable = true;
	desktopManager.xfce.enable = true;
#	windowManager.xmonad.enable = true;
#	windowManager.awesome.enable = true;
	desktopManager.default = "kde4";
	displayManager.kdm.enable = true;
#	displayManager.slim.enable = true;
	autorun = false;
	};

  environment.systemPackages = with pkgs; [
	acpitool
	ddrescue
	flashplayer
	glxinfo
	hdparm
	mssys
	ntfs3g
	rsync	
	screen
	smartmontools
	curl
	firefox
	gcc
	sudo
	strace
	wget
	zsh
	kde4.ark
	kde4.gwenview
	kde4.k3b
	kde4.k9copy
	kde4.kate
	kde4.kde_baseapps
	kde4.kde_workspace
	kde4.konsole
	kde4.ksnapshot
	kde4.kuser
	kde4.l10n.ja
	kde4.okular
	kde4.oxygen_icons
	kde4.polkit_kde_agent
	];
}
