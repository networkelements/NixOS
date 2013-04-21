 # This is a generated file.  Do not modify!
 # Make changes to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  require = [
    <nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
      initrd.kernelModules = [ "ehci_hcd" "ahci" "usbhid" "btrfs" "ext4" "ntfs" ];
      kernelModules = [ "zram" "kvm-intel" ];
      extraModulePackages = [ ];
      };

  powerManagement = {
	enable = true;
#	powerUpCommands="/var/run/current-system/sw/sbin/hdparm -y /dev/sda";
#	cpuFreqGovernor = "performance";
	};

  security.apparmor.enable = true;
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.rngd.enable = true;
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  services = {
	virtualbox.enable = true;
	ntp.servers = [ "ntp.nict.jp" ];
	acpid.enable = true;
    };


  nix.maxJobs = 4;

  boot.loader.grub = {
  version = 2;
  enable = true;
	device = "/dev/sda";
	};

  fileSystems =
	[{ mountPoint = "/";
	   device = "/dev/disk/by-label/nixos";
	   fsType = "ext4";
	 }
	];

#  i18n = {
#	consoleKeyMap = "jp106";
#	defaultLocale = "ja_JP.UTF-8";
#	};

  fonts = {
	enableFontConfig = true;
	#extraFonts = [ pkgs.ubuntu-font-family ];
      };

  time = {
	timeZone = "Asia/Tokyo";
	};

  services.xserver = {
	enable = true;
	driSupport = true;
	videoDriver = "intel";
#	layout = "jp";
	xkbModel = "jp106";
#	desktopManager.xfce.enable = true;
	desktopManager.kde4.enable = true;
#	windowManager.xmonad.enable = true;
#	windowManager.awesome.enable = true;
#	displayManager.slim.enable = true;
	displayManager.kdm.enable = true;
	desktopManager.default = "kde4";
	autorun = false;
	};

  environment.systemPackages = with pkgs; [
# minimal KDE
	kde4.kde_baseapps
#	kde4.l10n.ja
# KDE
#	kde4.ark
#	kde4.gwenview
#	kde4.k3b
#	kde4.kate
#	kde4.kde_workspace
#	kde4.konsole
#	kde4.ksnapshot
#	kde4.kuser
#	kde4.okular
#	kde4.oxygen_icons
#	kde4.polkit_kde_agent
# security
	pmount
	polkit
	rng_tools
	sudo
# useful?
	curl
	firefox
	git
	strace
	unrar
	unzip
	wget
	zsh
	];
}
