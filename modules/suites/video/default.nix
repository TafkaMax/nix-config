{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.video;
in
{
  options.nixos-snowfall.suites.video = with types; {
    enable = mkBoolOpt false "Whether or not to enable video configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      apps = {
        obs = enabled;
      };
    };
  };
}
