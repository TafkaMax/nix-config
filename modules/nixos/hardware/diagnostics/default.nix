{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.hardware.diagnostics;
in
{
  options.nixos-snowfall.hardware.diagnostics = with types; {
    enable = mkBoolOpt false "Whether or not to enable diagnostics support";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ dmidecode ]; };
}
