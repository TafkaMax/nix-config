{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.games;
in
{
  options.nixos-snowfall.suites.games = with types; {
    enable = mkBoolOpt false "Whether or not to enable games configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      apps = {
        steam = enabled;
      };
    };
  };
}
