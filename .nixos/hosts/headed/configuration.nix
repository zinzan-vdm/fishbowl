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
        current.libnotify
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

  security.polkit.enable = true;
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

  systemd.services.sleep-log-on-suspend = {
    description = "Sleep Log - on suspend (/tmp/sleep-log).";
    wantedBy = [ "sleep.target" "hibernate.target" "hybrid-sleep.target" ];
    before = [ "systemd-suspend.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${current.writeShellScript "sleep-log-on-suspend" ''
        echo "$(date --rfc-3339=ns) :: on suspend" >> /tmp/sleep-log
      ''}";
    };
  };
  systemd.services.sleep-log-off-suspend = {
    description = "Sleep Log - off suspend (/tmp/sleep-log).";
    wantedBy = [ "sleep.target" "hibernate.target" "hybrid-sleep.target" ];
    after = [ "systemd-suspend.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${current.writeShellScript "sleep-log-off-suspend" ''
        echo "$(date --rfc-3339=ns) :: off suspend" >> /tmp/sleep-log
      ''}";
    };
  };
  systemd.services.sleep-log-on-hibernate = {
    description = "Sleep Log - on hibernate (/tmp/sleep-log).";
    wantedBy = [ "sleep.target" "hibernate.target" "hybrid-sleep.target" ];
    before = [ "systemd-hibernate.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${current.writeShellScript "sleep-log-on-hibernate" ''
        echo "$(date --rfc-3339=ns) :: on hibernate" >> /tmp/sleep-log
      ''}";
    };
  };
  systemd.services.sleep-log-off-hibernate = {
    description = "Sleep Log - off hibernate (/tmp/sleep-log).";
    wantedBy = [ "sleep.target" "hibernate.target" "hybrid-sleep.target" ];
    after = [ "systemd-hibernate.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${current.writeShellScript "sleep-log-off-hibernate" ''
        echo "$(date --rfc-3339=ns) :: off hibernate" >> /tmp/sleep-log
      ''}";
    };
  };

  system.stateVersion = "24.05";
}

