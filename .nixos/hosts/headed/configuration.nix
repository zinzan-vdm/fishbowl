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
        unstable.sunsetr
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
        current.libnotify
        current.grim
        current.swappy
        current.slurp
        current.wayvnc
        # apps
        unstable.google-chrome
        unstable.discord-canary # discord-ptb if you dont want bleeding edge
        unstable.obs-studio
        # lenovo
        unstable.lenovo-legion
      ];
    };
  };

  programs.virt-manager.enable = true;

  # install the wayvnc service
  systemd.user.services.wayvnc = {
    description = "WayVNC VNC server";
    after = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${current.wayvnc}/bin/wayvnc --render-cursor --seat=seat0 --output=HDMI-A-1 0.0.0.0";
      Restart = "on-failure";
      RestartSec = 5;
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

  # hibernation see https://nixos.wiki/wiki/Hibernation
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "hibernate";
    powerKeyLongPress = "poweroff";
    extraConfig = ''
      SuspendState=mem
      HibernateDelaySec=30m
    '';
  };
  boot.kernelParams = [
    "consoleblank=0"
    "mem_sleep_default=deep"
    "resume=/dev/disk/by-label/SWAP"
  ];
  security.protectKernelImage = false;

  system.stateVersion = "24.05";
}

