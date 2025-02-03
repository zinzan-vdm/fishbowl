{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    ../headless/configuration.nix # builds on headless
  ];

  environment.systemPackages = [
    current.libjack2
    current.jack2
    current.jack2Full
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
        current.xdg-desktop-portal-hyprland
        current.xdg-utils
        current.wf-recorder
        # ux
        current.waybar
        current.hyprpaper
        current.swaylock-effects
        current.swayidle
        current.shared-mime-info
        current.wl-clipboard
        current.wlsunset
        current.foot
        # device
        current.networkmanagerapplet
        current.brightnessctl
        # tools
        current.dunst
        current.grim
        current.swappy
        current.slurp
        # apps
        unstable.google-chrome
        unstable.obs-studio
      ];
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.pam.services.swaylock = {
    name = "swaylock";
    text = "auth include login";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  powerManagement.enable = true;
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
    SuspendState=freeze mem disk
  '';

  boot.kernelParams = [ "consoleblank=0" ];

  system.stateVersion = "24.05";
}

