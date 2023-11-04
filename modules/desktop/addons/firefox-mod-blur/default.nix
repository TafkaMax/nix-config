{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.desktop.addons.firefox-mod-blur;
  profileDir = ".mozilla/firefox/${config.nixos-snowfall.user.name}";
in
{
  options.nixos-snowfall.desktop.addons.firefox-mod-blur = with types; {
    enable = mkBoolOpt false "Whether to enable the Blur theme for firefox.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.apps.firefox = {
      extraConfig = "user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true)";
      userChrome = ''
        @import "${pkgs.nixos-snowfall.firefox-mod-blur}/userChrome.css";
      '';
    };
    nixos-snowfall.home = {

      #file = {
      #  ".mozilla/firefox/${config.nixos-snowfall.user.name}/chrome/image/" = "${pkgs.nixos-snowfall.firefox-mod-blur}/image/";
      #  ".mozilla/firefox/${config.nixos-snowfall.user.name}/chrome/acrylic_micaforeveryone.css" = "${pkgs.nixos-snowfall.firefox-mod-blur}/EXTRA THEMES/MicaForEveryone Files/acrylic_micaforeveryone.css";
      #};
      extraOptions = {
        programs.firefox = {
          profiles.${config.nixos-snowfall.user.name} = {
            userContent = ''
              @import "${pkgs.nixos-snowfall.firefox-mod-blur}/userContent.css";
            '';
          };
        };
      };
    };
  };
}
