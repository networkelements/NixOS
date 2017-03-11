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
  };
  
  i18n = 
  {
  	consoleFont = "ipafont-003.03 hanazono vista-fonts-1";
	consoleKeyMap = "jp106";
	defaultLocale = "ja.JP_UTF-8";
	inputMethod =
	{
		enabled = "fcitx";
		engines = with pkgs.fcitx-engines; [ mozc anthy ];
	};
  };
  
  time.timeZone = "Asia/Tokyo";
  
  environment.systemPackages = with pkgs; 
  [
  	curl
	wget
	fcitx
	fcitx-configtool
	fcitx-engines.mozc
	#f2fs-tools
	fish
	git
	cryptsetup
	firefox
	#chromiumBeta
	emacs24-nox
	#deadbeef
	#mpv
	#neovim
	sudo
	vim
	mosh
	tmux
	#atom
	#yi
	#stack

  ];
  
  nixpkgs.config.allowUnfree = true;
  
  services = 
  {
  	openssh.enable = false;
	#printing.enable = true;
	xserver = 
	{
		enable = true;
		layout = "jp";
		#xkblayout = "jp";
		xkbOptions = "japan";
		
		#displayManager =
		#{
			#kdm.enable = true;
			#kde4.enable = true;
		#};
		
		desktopManager =
		{
			gnome3.enable = true;
			default = "gnome3";
			xterm.enable = false;
		};
		
		#windowManager = 
		#{

			#xmonad.enable = true;
			#xmonad.enableContribAndExtras = true;
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
