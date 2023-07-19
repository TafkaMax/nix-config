{ pkgs, ... }:

{
  # Enable gdm and gnome.
  services = {
    xserver = {
      enable = true;
      # Remove xterm, because we dont need too many different terminals.
      excludePackages = [ pkgs.xterm ];
      # Enable Gnome Desktop Manager
      displayManager = {
        gdm.enable = true;
      };
      desktopManager = {
        gnome = {
          enable = true;
          extraGSettingsOverrides = ''
            [com.ubuntu.login-screen]
            background-repeat='no-repeat'
            background-size='cover'
            background-color='#777777'
            background-picture-uri='file:///etc/nixos/home/linux/gnome/wallpaper.jpg'
          '';
        };
      };
      layout = "us";
      libinput.enable = true;
    };
    # Remove additionaly connectivity and beginner setup things.
    gnome = {
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
      gnome-online-accounts.enable = false;
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };
  # Add gnome-tweaks and other tools to configure gnome.
  environment = {
    systemPackages = with pkgs; [
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnomeExtensions.user-themes
    ];
    # Remove unwanted packages that come with gnome otherwise.
    gnome.excludePackages = [
      pkgs.gnome-connections #rdp/remmina like tool
      pkgs.gnome-photos #photo gallery like thingy
      pkgs.gnome-text-editor
      pkgs.gnome-tour # welcome thingy that shows new things in a gnome release
      pkgs.gnome.adwaita-icon-theme # default icons
      pkgs.gnome.epiphany # web-browser, use firefox instead
      pkgs.gnome.evince # document reader, use libre instead
      pkgs.gnome.file-roller
      pkgs.gnome.geary # email client, use thundebird instead
      pkgs.gnome.gnome-backgrounds
      pkgs.gnome.gnome-calendar
      pkgs.gnome.gnome-characters
      pkgs.gnome.gnome-clocks
      pkgs.gnome.gnome-contacts
      pkgs.gnome.gnome-font-viewer
      pkgs.gnome.gnome-logs
      pkgs.gnome.gnome-maps
      pkgs.gnome.gnome-music
      pkgs.gnome.gnome-screenshot # screenshot utility, use flameshot instead
      pkgs.gnome.gnome-themes-extra
      pkgs.gnome.gnome-weather
      pkgs.gnome.simple-scan # document scanner utility
      pkgs.gnome.sushi
      pkgs.gnome.totem # video player, use vlc instead
      pkgs.gnome.yelp
      pkgs.orca
      # Not to remove yet
      #pkgs.gnome.nautilus
    ];
  };
}