# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  boot = 
  {
    loader =
    {	
    	systemd-boot.enable = true;
        #gummiboot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    initrd = 
    { 
      # https://bugzilla.kernel.org/show_bug.cgi?id=110941
      #kernelParams = [ "intel_pstate=no_hwp" ];
  
      kernelModules = 
        [ 
          "usb_storage" 
          "dm_snapshot" 
          "fbcon" 
          "kvm-intel"
          "tp_smapi"
        ];
      
      availableKernelModules = 
        [ 
          "ehci_pci" 
          "ahci" 
          "usb_storage" 
        ];
        
      #extraModulePackages = 
      #  [
      #    config.boot.kernelPackages.tp_smapi
      #  ];
    };
  };
  

  #fileSystems."/boot" =
  #  { device = "/dev/disk/by-label/boot";
  #    fsType = "f2fs";
  #  };
  

   #fileSystems."/" =
   # { 
   #   device = "/dev/disk/by-label/nixos";
   #   fsType = "f2fs";
   # };

  #swapDevices =  
  #	[
  #	  {
  #	    device = "/dev/disk/by-label/swap";
  #	  } 
  #	];
  	
    networking = 
    {
      hostName =  "destroyer";
      #wireless.enable = true;
    };

   i18n = {
  #   consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "jp106";
     defaultLocale = "ja.JP_UTF-8";
   };

   time.timeZone = "Asia/Tokyo";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; 
   [
      curl
      wget
      fcitx-configtool
      #f2fs-tools
      fish
      cryptsetup
      firefox
      #emacs24-nox
      #deadbeef
      #mpv
      #neovim
      vim
      #atom
      #yi
      #stack
    ];

  services = 
  {
    openssh.enable = false;
    #printing.enable = true;  #CUPS printing
  
    xserver = 
    {
      enable = true;
      layout = "jp";
      #xkblayout = "jp";
      xkbOptions = "japan";

      #displayManager 
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
  # > sudo useradd -m -g users -G wheel -s /root/.nix-profile/bin/fish muarsame ; passwd murasame
  users.extraUsers.username = 
  {
    createHome = true;
    home = "/home/murasame";
    description = "yappari kuchikukan ha saikou daze!";
    extraGroups = [ ];
    isSystemUser = true;
    #useDefaultShell = true;
    #useDefaultShell = "/usr/bin/fish";
    #useDefaultShell = "/root/.nix-profile/bin/fish";
  };
  
  
  environment.variables.PATH = ["$HOME/.local/bin"];
  #programs.zsh.enable = true;
  programs.fish.enable = true;






  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

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
