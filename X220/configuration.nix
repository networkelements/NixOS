# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
  [
  # Include the results of the hardware scan.
  	./hardware-configuration.nix
  ];
  
  networking = 
  {
  	hostName =  "X220-16-09";
	#wireless.enable = true;
	firewall =
	{
		enable = true;
		allowPing = true;
		pingLimit = "--limit 1/minute --limit-burst 10";
		logRefusedConnections = true;
		logRefusedPackets = true;
		checkReversePath = true;	#kernelHasRPFilter;
		logReversePathDrops = true;
		
		connectionTrackingModules =
		[
			#"ftp"
			#"irc"
			#"sane"
			#"sip"
			#"tftp"
			#"amanda"
			#"h323"
			#"netbios_sn"
			#"pptp"
			#"snmp"
		];
		
		autoLoadConntrackHelpers = false;	#

		allowedTCPPorts =
		[
			# for ssh
			49156
			
			# for https
			#443
			
			# for tfpts server(temporary uses cisco IOS upload/download)
			#69

			# for samba connection
			#139
			#445
		];

		#allowedUDPPorts =
		#[
			# for samba connection
			#137
			#138
		#];
		
		allowedUDPPortRanges =
		[
			# for mosh connection
			{
				from = 60000;
				to   = 60002;
			}
		];
	};
  };
  
  i18n = 
  {
  	consoleFont = "ipafont inconsolata ubuntu_font_family";
	consoleKeyMap = "jp106";
	defaultLocale = "ja.JP_UTF-8";
	inputMethod =
	{
		enabled = "fcitx";
		fcitx =
		{
			engines = with pkgs.fcitx-engines;
			[
				mozc
				anthy
			];
		};
	};
  };
  
  time.timeZone = "Asia/Tokyo";
  
  environment.systemPackages = with pkgs; 
  [
  	chrony
	#curl
	wget
	fcitx
	fcitx-configtool
	fcitx-engines.mozc
	#f2fs-tools
	fish
	git
	ipset
	cryptsetup
	firefox
	#chromiumBeta
	emacs24-nox
	#deadbeef
	#mpv
	#neovim
	sudo
	#vim
	mosh
	tmux
	#atom
	#yi
	#stack

  ];
  
  nixpkgs.config =
  {
	allowUnfree = true;
	chromium =
	{
		enablePepperFlash = true;
		enablepepperPDF = true;
		enableWideVine = true;
	};

  };
    
  fonts =
  {
	enableFontDir = true;
	enableGhostscriptFonts = true;
	fonts = with pkgs;
	[
		inconsolata
		ubuntu_font_family
		unifont
		vistafonts
		ipafont
		hanazono
		source-code-pro
		anonymousPro
		liberation_ttf
		liberation_ttf_from_source
		meslo-lg
		hack-font
		dejavu_fonts
	];
  };
  
  services = 
  {
  	openssh.enable = false;
	#printing.enable = true;

	chrony =
	{
		enable = true;
		servers =
		[
			"ntp.nict.jp iburst"
			"ats1.e-timing.ne.jp iburst"
			"ntp1.jpix.ad.jp iburst"
			"time.google.com iburst"
			#"ntp.jist.mfeed.ad.jp iburst"
			#"ntp.ring.go.jp iburst"
		];
	};
	
	xserver = 
	{
		enable = true;
		layout = "jp";
		#xkblayout = "jp";
		xkbOptions = "japan";
		
		displayManager =
		{	
			gdm.enable = true;
			#kdm.enable = true;
			#lightdm.enable = true;
			#sddm.enable = true;
		};
		
		desktopManager =
		{
			gnome3.enable = true;
			default = "gnome3";
			xterm.enable = false;
			#desktopManager.e19.enable = true;
			#kde4.enable = true;
		};
		
		#windowManager = 
		#{

			#xmonad.enable = true;
			#xmonad.enableContribAndExtras = true;
			#windowManager.default = "xmonad";
			#desktopManager.default = "none";
		#};
	};
  };	

  # > which fish
  ## change path fish shell
  # > sudo useradd -m -g users -G wheel,sudo -s /root/.nix-profile/bin/fish USERNAME ; passwd USERNAME
  users.extraUsers.username =   
  {
  	createHome = true;
	home = "/home/USERNAME";
	uid = 1000;
	#description = "testing";
	#extraGroups = [ sudo ];
	isSystemUser = true;
	useDefaultShell = true;
	#useDefaultShell = "/usr/bin/fish";
	#useDefaultShell = "/root/.nix-profile/bin/fish"
  };
  
  environment.variables.PATH = ["$HOME/.local/bin"];
  #programs.zsh.enable = true;
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = 
  #{
  	#isNormalUser = true;
  	#uid = 1000;
  #};

  # The NixOS release to be compatible with for stateful data such as databases.
  system =
  {
	stateVersion = "16.09";
	autoUpgrade =
	{
		enable = true;
		channel = https://nixos.org/channels/nixos-16.09;
	};  
  };

}
