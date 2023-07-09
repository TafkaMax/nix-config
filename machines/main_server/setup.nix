{ config, pkgs, lib, ... }:
{
    setup = {
      hostname = "nixos-server";
      keyboard = "us";
      screen = "big";
      podman.enable = true;
    };

    services.journald = {
      extraConfig = ''
        SystemMaxUse=20G
        Storage=persistent
      '';
      rateLimitBurst = 100000;
      rateLimitInterval = "0s";
    };

  imports = [
      ../../configuration.nix
      ./hardware_main_server.nix
      ./networking/networking.nix
      ./services/grafana.nix
      ./services/nas.nix
      ./services/prometheus.nix
      ./services/ssh-access.nix
      ./services/syncthing.nix
      ./services/torrenting.nix
      ./services/wireguard.nix
  ];

}
