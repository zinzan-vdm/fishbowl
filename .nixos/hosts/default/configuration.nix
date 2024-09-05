{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix # use the platform generated hardware config instead of our own
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.fish = {
    isNormalUser = true;
    home = "/home/fish";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  environment.systemPackages = [
    current.git
    current.killall
  ];

  home-manager.users.fish = {
    programs.home-manager.enable = true;
    home = {
      stateVersion = "24.05";
      username = "fish";
      homeDirectory = "/home/fish";
      packages = [
        current.home-manager
	# tools
        unstable.tmux
	unstable.neovim
	current.git
	current.zip
	current.unzip
	current.lazygit
	current.zoxide
        current.tree
	current.fd
	current.ripgrep
	current.fzf
	current.jq
	current.parallel
        current.stow
	current.sshfs
	# net
	current.wireguard-tools
	current.nebula
	current.linuxPackages.usbip
	# virt
	current.docker-compose
	# hosting
	unstable.flyctl
	# perf
        current.btop
        current.iftop
	# misc
	current.bc
	current.gnumake
	current.cmake
	current.gcc
	current.gnupg
      ];
    };
  };

  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      insecure-registries = ["docker.docpay.cluster"];
    };
  };

  fonts.packages = [
    current.lato
    current.dejavu_fonts
    current.noto-fonts
    current.noto-fonts-cjk
    current.noto-fonts-emoji
    current.font-awesome
    current.liberation_ttf
  ];

  networking = {
    hostName = "fishbowl";

    firewall = {
      enable = true;
      allowedTCPPorts = [
	5200
	3000
	3500
	60006
      ];
      allowedTCPPortRanges = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
    };

    networkmanager.enable = true;
    wireguard.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # if running on a device with a screen, this will kill the screen to prevent burn
    kernelParams = [ "consoleblank=60" ];

    # only required if mounting ntfs storage
    supportedFilesystems = [ "ntfs" ];
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i32b";
    keyMap = "us";
    earlySetup = true;
    packages = [
      current.terminus_font
    ];
  };

  # if running in HyperV, this enables everything required to run properly in guest mode
  # virtualisation.hypervGuest.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "24.05";
}

