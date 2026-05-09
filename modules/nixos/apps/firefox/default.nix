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
  cfg = config.${namespace}.apps.firefox;
  defaultSettings = {
    "browser.aboutwelcome.enabled" = false;
    "browser.meta_refresh_when_inactive.disabled" = true;
    "browser.startup.homepage" = "https://google.com";
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.ssb.enabled" = true;
  };
in
{
  options.${namespace}.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig = mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome = mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {

    services.gnome.gnome-browser-connector.enable = config.${namespace}.desktop.gnome.enable;

    # manage firefox using home-manager
    ${namespace} = {
      desktop.addons.firefox-mod-blur = enabled;
      home = {
        extraOptions = {
          programs.firefox = {
            enable = true;
            package = pkgs.firefox.override ({
              cfg = {
                enableBrowserpass = false;
                enableGnomeExtensions = config.${namespace}.desktop.gnome.enable;
              };

            });

            profiles.${config.${namespace}.user.name} = {
              inherit (cfg) extraConfig userChrome settings;
              id = 0;
              isDefault = true;
              name = config.${namespace}.user.name;
              #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              #  ublock-origin
              #  keepassxc-browser
              #  user-agent-string-switcher
              #  gnome-shell-integration
              #];
            };
          };
        };
      };
    };
  };
}
