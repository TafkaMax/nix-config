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
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "no-overview@fthx"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Console.desktop"
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
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch terminal";
      binding = "<Super>t";
      command = "kgx";
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
    # Sound output not supported yet.
    #gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.places-status-indicator
    gnomeExtensions.no-overview
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.workspace-indicator
  ];
}