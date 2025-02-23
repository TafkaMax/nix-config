{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.inkscape;
in
{
  options.nixos-snowfall.apps.inkscape = with types; {
    enable = mkBoolOpt false "Whether or not to enable Inkscape.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ inkscape-with-extensions ];
  };
}
