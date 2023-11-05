{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.services.printing;
in
{
  options.nixos-snowfall.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable { services.printing.enable = true; };
}
