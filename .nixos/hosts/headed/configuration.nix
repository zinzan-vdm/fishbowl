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
        unstable.obs-studio
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

  powerManagement.enable = true;
  hardware.nvidia.powerManagement.enable = true; # if you have a nvidia gpu

  # sleeping is weird on macbooks, this is the best i could get it to behave but its still not perfect...nixos
  # im using a real laptop now though so we're good
  # systemd.sleep.extraConfig = ''
  #   AllowSuspend=yes
  #   AllowHibernation=no
  #   AllowHybridSleep=no
  #   AllowSuspendThenHibernate=no
  #   SuspendState=freeze mem disk
  # '';

  boot.kernelParams = [ "consoleblank=0" ];

  system.stateVersion = "24.05";
}

