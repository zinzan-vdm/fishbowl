{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix # use the platform generated hardware config instead of our own
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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
	current.lazygit
	current.zoxide
        current.tree
	current.fd
	current.ripgrep
	current.fzf
	current.parallel
        current.stow
	# net
	current.wireguard-tools
	current.nebula
	# virt
	current.docker-compose
	# perf
        current.btop
        current.iftop
	# misc
	current.gnumake
	current.cmake
	current.gcc
	current.gnupg
      ];
    };
  };

  users.users.fish = {
    isNormalUser = true;
    home = "/home/fish";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  environment.systemPackages = [
    current.vim
    current.git
  ];

  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      insecure-registries = [];
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

    firewall.enable = true;

    networkmanager.enable = true;
    wireguard.enable = true;
  };

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
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # if running in HyperV, this enables everything required to run properly in guest mode
  # virtualisation.hypervGuest.enable = true;

  system.stateVersion = "24.05";
}
