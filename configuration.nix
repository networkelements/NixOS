 #This is a generated file.  Do not modify!
 # Make changes to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  require = [
    <nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
      initrd.kernelModules = [ "ehci_hcd" "ahci" "usbhid" "i915" "btrfs" "ext4" "ntfs" ];
      kernelModules = [ "zram" "kvm-intel" ];
      extraModulePackages = [ ];
      #extraModulePackages = [ "pkgs.linuxPackages.virtualbox" "kernel.virtualboxGuestAdditions" ];
      postBootCommands = "${pkgs.procps}/sbin/sysctl -w vm.swappiness=10";
      };

  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };

  powerManagement = {
	enable = true;
	powerUpCommands="/var/run/current-system/sw/sbin/hdparm -y /dev/sda";
	powerManagement.cpuFreqGovernor = "performance";
	};

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  services = {
      nixosManual.showManual = true;			#Add the NixOS Manual on virtual console 8
      virtualbox.enable = true;
#Enable helpful DBus services.(Xfce)
     udisks.enable = true;
     upower.enable = config.powerManagement.enable;
      ntp.servers = [ "ntp.nict.jp" ];
      acpid.enable = true;
      udev = {
	packages = [ pkgs.ffado ]; # If you have a FireWire audio interface
	extraRules = ''
	  KERNEL=="rtc0", GROUP="audio"
	  KERNEL=="hpet", GROUP="audio"
	'';
      };
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
	   fsType = "btrfs";
	 }
	];

  i18n = {
	consoleKeyMap = "jp106";
	defaultLocale = "ja_JP.UTF-8";
	};

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
	layout = "jp";
	xkbModel = "jp106";
	desktopManager.xfce.enable = true;
	desktopManager.kde4.enable = true;
#	windowManager.xmonad.enable = true;
#	windowManager.awesome.enable = true;
#	displayManager.slim.enable = true;
	displayManager.kdm.enable = true;
	desktopManager.default = "xfce";
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
# minimal KDE
	kde4.kde_baseapps
	kde4.l10n.ja
# KDE
	kde4.ark
	kde4.gwenview
	kde4.k3b
	kde4.k9copy
	kde4.kate
	kde4.kde_workspace
	kde4.konsole
	kde4.ksnapshot
	kde4.kuser
	kde4.okular
	kde4.oxygen_icons
	kde4.polkit_kde_agent
# xfce
	gtk # To get GTK+'s themes.
	hicolor_icon_theme
	shared_mime_info
	which # Needed by the xfce's xinitrc script.
	xfce.exo
	xfce.gtk_xfce_engine
	xfce.libxfcegui4 # For the icons.
	xfce.ristretto
	xfce.terminal
	xfce.thunar
	xfce.xfce4icontheme
	xfce.xfce4panel
	xfce.xfce4session
	xfce.xfce4settings
	xfce.xfce4mixer
	xfce.xfceutils
	xfce.xfconf
	xfce.xfdesktop
	xfce.xfwm4
  # This supplies some "abstract" icons such as
  # "utilities-terminal" and "accessories-text-editor".
	gnome.gnomeicontheme
	desktop_file_utils
	xfce.libxfce4ui
	xfce.garcon
	xfce.thunar_volman
	xfce.gvfs
	xfce.xfce4_appfinder
# mozc dependencies
	#libibus-1.0-dev
	#libssl-dev
	#libdbus-1-dev
	#libglib2.0-dev
	subversion
	#devscripts
	#debhelper
	#libqt4-dev
	#libzinnia-dev
	#tegaki-zinnia-japanese
	#libgtk2.0-dev
	#libxcb-xfixes0-dev
	gcc
	python
# ibus dependencies
	#gnome-common
	#autoconf-2.53
	#automake-1.10
# HDD
	acpitool
	hdparm
	parted
	rsync
	smartmontools
	#sshfs
	testdisk
# useful
	#alsamixer
	#ubuntu-font-family
	#xmodmap
	curl
	firefox
	git
	sudo
	strace
	unrar
	unzip
	wget
	zsh
	];
}
