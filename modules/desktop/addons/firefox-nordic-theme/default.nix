{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.desktop.addons.firefox-nordic-theme;
  profileDir = ".mozilla/firefox/${config.nixos-snowfall.user.name}";
in
{
  options.nixos-snowfall.desktop.addons.firefox-nordic-theme = with types; {
    enable = mkBoolOpt false "Whether to enable the Nordic theme for firefox.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.apps.firefox = {
      extraConfig = builtins.readFile
        "${pkgs.nixos-snowfall.firefox-nordic-theme}/configuration/user.js";
      userChrome = ''
        @import "${pkgs.nixos-snowfall.firefox-nordic-theme}/userChrome.css";
      '';
    };
  };
}
