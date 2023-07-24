{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.apps.kitty;
in
{
  options.nixos-snowfall.apps.kitty = with types; {
    enable = mkBoolOpt false "Whether or not to enable Kitty.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ kitty ]; };
}
