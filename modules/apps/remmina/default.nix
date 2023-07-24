{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.apps.remmina;
in
{
  options.nixos-snowfall.apps.remmina = with types; {
    enable = mkBoolOpt false "Whether or not to enable Remmina.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ remmina ]; };
}
