{ options, config, lib, pkgs, ... }:
with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.archetypes.workstation;
in
{
  options.nixos-snowfall.archetypes.workstation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the workstation archetype.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        art = enabled;
        video = enabled;
        work = enabled;
      };
    };
  };
}
