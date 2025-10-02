{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix # use the platform generated hardware config instead of our own
  ];

  hardware.enableAllFirmware = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.fish = {
    isNormalUser = true;
    home = "/home/fish";
    extraGroups = [ "wheel" "disk" "networkmanager" "docker" ];
    linger = true;
  };

  environment.systemPackages = [
    current.git
    current.killall
  ];

  home-manager.users.fish = {
    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
    home = {
      stateVersion = "24.05";
      username = "fish";
      homeDirectory = "/home/fish";
      packages = [
	current.home-manager
	# tools
	unstable.atuin
	unstable.tmux
	unstable.neovim
	unstable.httpie
	unstable.hurl
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
	current.woof
	current.qrencode
	current.speechd
	# net
	current.wireguard-tools
	current.nebula
	current.linuxPackages.usbip
	# virt
	current.podman-tui
	current.podman-compose
	# hosting
	unstable.flyctl
	unstable.miniserve
	# perf
	current.btop
	current.iftop
	# llm/ai
	unstable.aichat
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

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers.backend = "podman";
  };

  fonts.packages = [
    current.lato
    current.dejavu_fonts
    current.noto-fonts
    current.noto-fonts-cjk-sans
    current.noto-fonts-emoji
    current.liberation_ttf
    unstable.font-awesome
    unstable.nerd-fonts.jetbrains-mono
    unstable.nerd-fonts.fira-code
  ];

  networking = {
    hostName = "fishbowl";

    firewall = {
      enable = true;
      allowedTCPPorts = [
	8080
	8081
	8082
	8083
	8084
	8085
      ];
      allowedTCPPortRanges = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
    };

    networkmanager.enable = true;
    wireguard.enable = true;
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
	Enable = "Source,Sink,Media,Socket";
	Experimental = true;
	FastConnectable = true;
	UserspaceHID = true;
      };
    };
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

    # See below section on power management (tlp)
    extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
    kernelModules = [ "acpi_call" ];
  };

  # power management for battery longevity
  # heat kills bats, <20% kills bats, prolonged 100% kills bats, heat decimates bats
  # tips? never <20%, avoid 100% unless needed, defnitely dont roast at 100%, maybe cooling packs for high load (ie gaming)
  # simple solution, start charge at 40%, stop at 80%
  # maybe cycle 20% -> 100% -> 20% once a month to recalibrate battery meters (mostly for software to accurately read)
  # we can use tlp for controls
  # lenovo uses acpi_call to mod bat controls, it also has BIOS settings to cap for you somewhere if you want hardware caps
  services.tlp = {
    enable = true;
    settings = {
      # generally decent for most laptops
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # my laptop uses 1/0 for conservation mode instead of percentages.
      # START_CHARGE_THRESH_BAT0 = "40";
      # STOP_CHARGE_THRESH_BAT0  = "80";
      STOP_CHARGE_THRESH_BAT0 = "1";

      # tlp disables masks systemd-rfkill to avoid conflicting power saving policies.
      # we can use tlp to set devices and bypass rfkill
      DEVICES_TO_DISABLE_ON_STARTUP = "";
      DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi wwan";

      USB_AUTOSUSPEND = 1;
    };
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

