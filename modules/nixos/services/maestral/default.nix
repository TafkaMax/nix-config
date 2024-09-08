{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.services.maestral;
in
{
  options.nixos-snowfall.services.maestral = with types; {
    enable = mkBoolOpt false "Whether or not to configure maestral support.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ maestral maestral-gui ];
  };
}
