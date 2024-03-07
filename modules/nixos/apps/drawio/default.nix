{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.drawio;
in
{
  options.nixos-snowfall.apps.drawio = with types; {
    enable = mkBoolOpt false "Whether or not to enable Draw IO.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ drawio ];
  };
}
