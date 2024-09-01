{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    ../headless/configuration.nix # basic builds on headless
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.pam.services.swaylock = {
    name = "swaylock";
    text = "auth include login";
  };

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

  system.stateVersion = "24.05";
}

