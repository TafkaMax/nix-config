{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.transmission;
in
{
  options.nixos-snowfall.apps.transmission = with types; {
    enable = mkBoolOpt false "Whether or not to enable Transmission bittorrent client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ transmission ];
  };
}
