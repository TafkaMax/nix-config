{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.libreoffice;
in
{
  options.nixos-snowfall.apps.libreoffice = with types; {
    enable = mkBoolOpt false "Whether or not to enable Libreoffice.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libreoffice ];
  };
}
