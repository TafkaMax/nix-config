{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.misc-work;
in
{
  options.nixos-snowfall.tools.misc-work = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities for work PC.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lldpd
    ];
    services.lldpd.enable = true;
  };
}
