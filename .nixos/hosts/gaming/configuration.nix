{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    ../basic/configuration.nix # gaming builds on basic
  ];

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  system.stateVersion = "24.05";
}

