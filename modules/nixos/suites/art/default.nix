{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.art;
in
{
  options.nixos-snowfall.suites.art = with types; {
    enable = mkBoolOpt false "Whether or not to enable art configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      apps = {
        gimp = enabled;
      };
    };
  };
}
