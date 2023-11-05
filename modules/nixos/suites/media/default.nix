{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.media;
in
{
  options.nixos-snowfall.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      apps = {
        spotify = enabled;
        transmission = enabled;
      };
    };
  };
}
