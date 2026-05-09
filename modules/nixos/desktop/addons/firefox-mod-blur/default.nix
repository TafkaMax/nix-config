{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.firefox-mod-blur;
  profileDir = ".mozilla/firefox/${config.${namespace}.user.name}";
in
{
  options.${namespace}.desktop.addons.firefox-mod-blur = with types; {
    enable = mkBoolOpt false "Whether to enable the Blur theme for firefox.";
  };

  config = mkIf cfg.enable {
    ${namespace}.apps.firefox = {
      extraConfig = "user_pref(\"toolkit.legacyUserProfileCustomizations.stylesheets\", true)";
      userChrome = ''
        @import "${pkgs.${namespace}.firefox-mod-blur}/userChrome.css";
      '';
    };
    ${namespace}.home = {

      #file = {
      #  ".mozilla/firefox/${config.${namespace}.user.name}/chrome/image/" = "${pkgs.${namespace}.firefox-mod-blur}/image/";
      #  ".mozilla/firefox/${config.${namespace}.user.name}/chrome/acrylic_micaforeveryone.css" = "${pkgs.${namespace}.firefox-mod-blur}/EXTRA THEMES/MicaForEveryone Files/acrylic_micaforeveryone.css";
      #};
      extraOptions = {
        programs.firefox = {
          profiles.${config.${namespace}.user.name} = {
            userContent = ''
              @import "${pkgs.${namespace}.firefox-mod-blur}/userContent.css";
            '';
          };
        };
      };
    };
  };
}
