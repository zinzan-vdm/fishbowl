{ config, lib, current, unstable, inputs, ... }:

{
  imports = [
    ../headed/configuration.nix # builds on headed
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

