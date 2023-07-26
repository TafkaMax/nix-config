{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.apps.dbeaver;
in
{
  options.nixos-snowfall.apps.dbeaver = with types; {
    enable = mkBoolOpt false "Whether or not to enable Element.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dbeaver ];
  };
}
