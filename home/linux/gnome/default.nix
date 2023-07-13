{ pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela-Circle";
      package = pkgs.tela-circle-icon-theme;
    };
    cursorTheme = {
      name = "Capitaine-Cursors";
      package = pkgs.capitaine-cursors-themed;
    };
    theme = {
      name = "orchis";
      package = pkgs.orchis-theme;
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
  home.sessionVariables.GTK_THEME = "orchis";
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "spotify.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "orchis";
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.sound-output-device-chooser
  ];
}