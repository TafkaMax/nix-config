{ pkgs, ... }:

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
        "obsidian.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "org.remmina.Remmina.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
      toolkit-accessibility = false;
      clock-show-weekday = true;
      gtk-theme = "Fluent-round-Light";
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
    #"org/gnome/desktop/wm/keybindings" = {
    #  activate-window-menu = "disabled";
    #  toggle-message-tray = "disabled";
    #  close = [ "<Super>q" ];
    #  maximize = "disabled";
    #  minimize = [ "<Super>comma" ];
    #  move-to-monitor-down = "disabled";
    #  move-to-monitor-left = "disabled";
    #  move-to-monitor-right = "disabled";
    #  move-to-monitor-up = "disabled";
    #  move-to-workspace-down = "disabled";
    #  move-to-workspace-up = "disabled";
    #  toggle-maximized = [ "<Super>m" ];
    #  unmaximize = "disabled";
    #};
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