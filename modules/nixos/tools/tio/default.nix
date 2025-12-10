{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.tio;
in
{
  options.nixos-snowfall.tools.tio = with types; {
    enable = mkBoolOpt false "Whether or not to enable common tio utilities.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ tio ]; };
}
