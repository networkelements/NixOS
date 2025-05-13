# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #services.systemd-resolved.enable = false;  # systemd-resolved を無効化

  networking = {
    hostName = "NixOS01";                   # Define your hostname.
    useNetworkd = true;                     # NetworkManager を使用
    networkmanager.enable = true;           # NetworkManager を有効化
    nameservers = [ "1.1.1.1" "8.8.8.8" ];  # DNS サーバーを設定
    #resolvConf = "/etc/resolv.conf";        # resolv.conf を直接設定
    defaultGateway = {
      address = "114.51.4.1";
      interface = "enp6s18";
    };
    #defaultGateway6 = {
    #  address = "fe80::1";
    #  interface = "enp6s18";
    #};
    interfaces."enp6s18" = {
      ipv4 = {
        addresses = [
          { address = "114.51.4.19"; prefixLength = 8; }
        ];
      };
      #ipv6 = {
      #  addresses = [
      #    { address = "2001:db8::1"; prefixLength = 64; }
      #  ];
      #};
      #dhcpFallback = true;  # DHCP フォールバックを有効化
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    shell = pkgs.fish;
    # description = lib.mkDefault "root";  # 上書きする場合
  };

  users.users.networkelements = {
    isNormalUser = true;
    description = "networkelements";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;  # デフォルトシェルを fish に変更
    #packages = with pkgs; [
    #  fish
    #];
  };

  programs.fish.enable = true;

  # nopasswd sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bottom
    cifs-utils
    dive
    docker-compose
    fish
    git
    htop
    neovim
    podman
    podman-tui
    postgresql
    redis
    tmux
    vim
    zellij
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # SSH設定: 公開鍵認証を有効化、ポートを49152に変更
  services.openssh = {
    enable = true;
    ports = [ 49152 ];
    settings = {
      PermitRootLogin = "no";
      UsePAM = false;
      PubkeyAuthentication = true;
      PasswordAuthentication = true;
      PermitEmptyPasswords = "no";
      ChallengeResponseAuthentication = false;
    };
  };

  # ファイアウォール設定: SSHポートとPodman用のポートを許可、それ以外はdrop
  networking.firewall = {
    enable = true;
    allowPing = true;               # ICMP(ping)を無効化（任意）
    checkReversePath = "loose";     # RPFチェック（任意）
    rejectPackets = true;           # デフォルトで拒否（trueだとREJECT、falseだとDROP）
    allowedTCPPorts = [ 49152 123 124 125 126 127 80 443 22 ]; # SSH用ポートとPodman(123-127),gitlab,sambaのデフォルトポート
    allowedUDPPorts = [ 49152 123 124 125 126 127 53 ];        # SSH用ポートとPodman(123-127),dnsのデフォルトポート
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # CIFS マウント設定
  # 所有権を自動で設定する
  systemd.tmpfiles.rules = [
    "d /mnt/ceph01 0775 networkelements wheel -"
    "d /mnt/18TB03 0775 networkelements wheel -"
  ];

  fileSystems."/mnt/ceph01" = {
    device = "//19.19.81.0/ceph01";
    options = [
      "_netdev"
      "file_mode=0774"
      "dir_mode=0775"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "user"
      "users"
      #"uid=1000"          # networkelements's UID (from `id -u networkelements`)
      #"gid=1"             # wheel group GID (from `id -g wheel`)
      "credentials=/etc/.smbpswd1"
    ];
  };

  fileSystems."/mnt/18TB03" = {
    device = "//11.4.51.4/18TB03";
    options = [
      "_netdev"
      "file_mode=0774"
      "dir_mode=0775"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "user"
      "users"
      #"uid=1000"          # networkelements's UID (from `id -u networkelements`)
      #"gid=1"             # wheel group GID (from `id -g wheel`)
      "credentials=/etc/.smbpswd"
    ];
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
