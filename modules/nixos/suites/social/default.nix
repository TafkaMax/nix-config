{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.social;
in
{
  options.nixos-snowfall.suites.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      apps = {
        element = enabled;
        telegram-desktop = enabled;
      };
    };
  };
}
