{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.desktop.addons.firefox-cascade-theme;
  profileDir = ".mozilla/firefox/${config.nixos-snowfall.user.name}";
in
{
  options.nixos-snowfall.desktop.addons.firefox-cascade-theme = with types; {
    enable = mkBoolOpt false "Whether to enable the Cascade theme for firefox.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.apps.firefox = {
      userChrome = ''
        @import "${pkgs.nixos-snowfall.firefox-cascade-theme}/chrome/userChrome.css";
      '';
    };
  };
}
