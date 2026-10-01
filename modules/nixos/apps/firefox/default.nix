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
  addons = pkgs.nur.repos.rycee.firefox-addons;

  # Not available in rycee's NUR repo, packaged from addons.mozilla.org.
  passwork-self-hosted = addons.buildFirefoxXpiAddon rec {
    pname = "passwork-self-hosted";
    version = "2.0.38";
    addonId = "{5772be84-2f2f-49a8-8236-0e002ce5165d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4836655/passwork_self_hosted-${version}.xpi";
    sha256 = "a1537a8fbc206ad689d45a3d1b2f489f5cda471518e35cc41106c6764e289b05";
    meta = {
      description = "Passwork self-hosted browser extension";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  };

  extensionPackages = with addons; [
    ublock-origin
    keepassxc-browser
    user-agent-string-switcher
    gnome-shell-integration
    passwork-self-hosted
  ];

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
            configPath = "${
              config.home-manager.users.${config.${namespace}.user.name}.xdg.configHome
            }/mozilla/firefox";
            package = pkgs.firefox.override ({
              cfg = {
                enableBrowserpass = false;
                enableGnomeExtensions = config.${namespace}.desktop.gnome.enable;
              };

            });

            # Allow all managed extensions to run in private windows.
            policies.ExtensionSettings = listToAttrs (
              map (p: nameValuePair p.addonId { private_browsing = true; }) extensionPackages
            );

            profiles.${config.${namespace}.user.name} = {
              inherit (cfg) extraConfig userChrome;
              settings = cfg.settings // {
                # Enable extensions installed by home-manager without asking.
                "extensions.autoDisableScopes" = 0;
              };
              id = 0;
              isDefault = true;
              name = config.${namespace}.user.name;
              extensions = {
                force = true; # For migration from self-managed to nix managed.
                packages = extensionPackages;

                settings."uBlock0@raymondhill.net".settings = {
                  selectedFilterLists = [
                    "ublock-filters"
                    "ublock-badware"
                    "ublock-privacy"
                    "ublock-unbreak"
                    "ublock-quick-fixes"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
