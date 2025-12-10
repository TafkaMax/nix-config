{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.zoom-us;
in
{
  options.nixos-snowfall.apps.zoom-us = with types; {
    enable = mkBoolOpt false "Whether or not to enable zoom-us.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ zoom-us ]; };
}
