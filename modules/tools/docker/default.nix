{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.docker;
in
{
  options.nixos-snowfall.tools.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable common docker utilities.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ docker-compose ]; };
}
