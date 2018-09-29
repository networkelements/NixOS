# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = 
  {
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    hostName = "vps";
  };

  i18n = 
  {
  	consoleFont = "ipafont";
	  consoleKeyMap = "jp106";
	  defaultLocale = "ja.JP_UTF-8";
  };
  
  time.timeZone = "Asia/Tokyo";
 
  fonts =
  {
	 enableFontDir = true;
	 #fontconfig =
	 #{
	 # enable = true;
	 # antialias = true;
	 #};
	
	 enableGhostscriptFonts = true;
	 fonts = with pkgs;
	 [
		 ubuntu_font_family
		 unifont
	 	 ipafont
	   hanazono
		 hack-font
	 ];
  };

  nixpkgs.config =
  {
	allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     emacs fish tmux openssh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 49000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = false;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.username =   
  {
  	createHome = true;
  	home = "/home/MoshinNagant";
  	uid = 1000;
  	#description = "testing";
  	#extraGroups = [ ];
  	isSystemUser = true;
  	useDefaultShell = true;
  	shell = "/nix/var/nixprofiles/default/bin/fish";
 };

 programs.fish.enable = true;
 programs.fish.enableCompletion = true; 
 environment.variables.PATH = ["$HOME/.local/bin"];



  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
