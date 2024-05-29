{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.yed;
in
{
  options.nixos-snowfall.apps.yed = with types; {
    enable = mkBoolOpt false "Whether or not to enable yed.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ yed ]; };
}
