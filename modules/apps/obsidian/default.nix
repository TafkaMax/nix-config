{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.apps.obsidian;
in
{
  options.nixos-snowfall.apps.obsidian = with types; {
    enable = mkBoolOpt false "Whether or not to enable Obsidian.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ obsidian ]; };
}
