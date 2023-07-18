{ pkgs, lib, ... }:
let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Fluent";
      package = pkgs.fluent-icon-theme;
    };
    cursorTheme = {
      name = "Capitaine Cursors - White";
      package = pkgs.capitaine-cursors-themed;
    };
    theme = {
      name = "Fluent-round-Light";
      package = pkgs.fluent-gtk-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=0
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=0
      '';
    };
  };
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = "disabled";
      enabled-extensions = [
        #builtin extensions
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        #explicitly added
        "no-overview@fthx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "pano@elhan.io"
        "hotedge@jonathan.jdoda.ca"
        "pop-shell@system76.com"
        "AlphabeticalAppGrid@stuarthayhurst"
        "just-perfection-desktop@just-perfection"
        "freon@UshakovVasilii_Github.yahoo.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        # Remove built-in console from favourites
        #"org.gnome.Console.desktop"
        "org.remmina.Remmina.desktop"
        "obsidian.desktop"
        "spotify.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
      toolkit-accessibility = false;
      clock-show-weekday = true;
      gtk-theme = "Fluent-round-Light";
      show-battery-percentage = true;
      font-name = "Noto Sans 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
      document-font-name = "Noto Sans 11";
      font-hinting = "slight";
      font-antialiasing = "grayscale";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Noto Sans 11";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Fluent-round-Light";
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///etc/nixos/home/linux/gnome/wallpaper.jpg";
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///etc/nixos/home/linux/gnome/wallpaper.jpg";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch terminal";
      binding = "<Super>t";
      command = "kitty";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Flameshot screenshot";
      binding = "<Super>Print";
      command = "flameshot gui";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ee" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
      show-all-sources = true;
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.places-status-indicator
    gnomeExtensions.no-overview
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.improved-workspace-indicator
    gnomeExtensions.appindicator
    gnomeExtensions.pano
    gnomeExtensions.hot-edge
    gnomeExtensions.pop-shell
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.just-perfection
    gnomeExtensions.freon
    # Not supported yet.
    #gnomeExtensions.sound-output-device-chooser
    #gnomeExtensions.top-panel-workspace-scroll
  ];
}