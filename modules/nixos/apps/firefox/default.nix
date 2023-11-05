{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.firefox;
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
  options.nixos-snowfall.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig =
      mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome =
      mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.desktop.addons.firefox-mod-blur = enabled;

    services.gnome.gnome-browser-connector.enable = config.nixos-snowfall.desktop.gnome.enable;

    # manage firefox using home-manager
    nixos-snowfall.home = {

      extraOptions = {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox.override (
            {
              cfg = {
                enableBrowserpass = false;
                enableGnomeExtensions = config.nixos-snowfall.desktop.gnome.enable;
              };

            }
          );

          profiles.${config.nixos-snowfall.user.name} = {
            inherit (cfg) extraConfig userChrome settings;
            id = 0;
            isDefault = true;
            name = config.nixos-snowfall.user.name;
            extensions = with config.nur.repos.rycee.firefox-addons; [
              ublock-origin
              keepassxc-browser
              user-agent-string-switcher
              gnome-shell-integration
            ];
          };
        };
      };
    };
  };
}
