{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.archetypes.gaming;
in
{
  options.nixos-snowfall.archetypes.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable the gaming archetype.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.suites = {
      common = enabled;
      desktop = enabled;
      social = enabled;
      media = enabled;
      #      games = enabled;
    };
  };
}
