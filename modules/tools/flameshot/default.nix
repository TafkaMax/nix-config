{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.nixos-snowfall.tools.flameshot;
in
{
  options.nixos-snowfall.tools.flameshot = with types; {
    enable = mkBoolOpt false "Whether or not to enable common flameshot utilities.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ flameshot ]; };
}
