{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
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
    #nixos-snowfall.desktop.addons.firefox-cascade-theme = enabled;
    nixos-snowfall.desktop.addons.firefox-mod-blur = enabled;

    services.gnome.gnome-browser-connector.enable = config.nixos-snowfall.desktop.gnome.enable;

    # manage firefox using home-manager
    nixos-snowfall.home = {
      #file = {
      #  ".mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json";

      #  ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = mkIf config.nixos-snowfall.desktop.gnome.enable "${pkgs.chrome-gnome-shell}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
      #};

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
            ];
          };
        };
      };
    };
  };
}
