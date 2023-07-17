{ pkgs, ... }:

{
  # Enable gdm and gnome.
  services = {
    xserver = {
      enable = true;
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
  };
  # Add gnome-tweaks.
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.user-themes
  ];
}