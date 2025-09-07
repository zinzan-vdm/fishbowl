{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    ../headless/configuration.nix # builds on headless
  ];

  environment.systemPackages = [
    current.libjack2
    current.jack2
    current.jack_capture
    current.qjackctl
    current.pavucontrol
    current.pulseaudio
    current.pamixer
    current.alsa-utils
  ];

  home-manager.users.fish = {
    programs.home-manager.enable = true;
    home = {
      stateVersion = "24.05";
      username = "fish";
      homeDirectory = "/home/fish";
      packages = [
        current.home-manager
        # wayland tooling
        current.xdg-utils
        current.wf-recorder
        # desktop
        current.hyprpolkitagent
        current.foot
        current.waybar
        current.hyprutils
        current.hyprpaper
        current.hypridle
        current.hyprlock
        current.hyprsunset
        current.hyprcursor
        current.shared-mime-info
        current.wl-clipboard
        current.clipse
        # device
        current.networkmanagerapplet
        current.brightnessctl
        current.udiskie
        # tools
        current.dunst
        current.grim
        current.swappy
        current.slurp
        # apps
        unstable.google-chrome
        unstable.discord-canary # discord-ptb if you dont want bleeding edge
        unstable.obs-studio
        # lenovo
        unstable.lenovo-legion
      ];
    };
  };

  # for mounting devices
  services.udisks2.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = {
    name = "hyprlock";
    text = "auth include login";
  };

  security.rtkit.enable = true; # recommended for pipewire to use realtime scheduler
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.nvidia.powerManagement.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
    powerDownCommands = ''
      echo deep > /sys/power/mem_sleep
    '';
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=30min
      HibernateDelaySec=2h # Time before going from suspend to hibernate
    '';
  };

  boot.resumeDevice = "/dev/disk/by-label/SWAP"; # ensure this is your swap device, otherwise use resume & resume_offset below
  boot.kernelParams = [
    "consoleblank=0"
    "mem_sleep_default=deep"

    # only use if using swapfile
    # "resume="
    # "resume_offset=0" # get your offset using `sudo filefrag -v /swapfile`
  ];

  system.stateVersion = "24.05";
}

