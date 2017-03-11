# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot =
  {
    loader =
    {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      
      grub =
      {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "nodev";
        #device = "/dev/sda";
        #device = "/dev/sda1";
        #devices = [ "/dev/sda1" ];
        #devices = [ "/dev/sda2" ];
      };
    };
    
    initrd = 
    {
      availableKernelModules = 
      [
        "ehci_pci" 
        "ahci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "sdhci_pci"
      ];
      
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
      
      luks =
      {
        mitigateDMAAttacks = true;
        
        devices =
        [
          {
            name = "root";
            preLVM = true;
            device = "/dev/disk/by-uuid/748c12c1-dac0-4148-8be7-f9e59d150633";
            #allowDiscards = true;
          };
	  
          cryptoModules =
          {
          	[
          		"aes"
          		"xts"
          		"sha256"
			"sha1"
			"cbc"
          	];
          };
        ];
      };
    };
    
    extraModulePackages =
    [
      config.boot.kernelPackages.tp_smapi
    ];
  };

  fileSystems."/" =
    { 
      device = "/dev/disk/by-uuid/748c12c1-dac0-4148-8be7-f9e59d150633";
      fsType = "f2fs";
    };

  fileSystems."/boot" =
    { 
      device = "/dev/disk/by-uuid/2643-DA52";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}
