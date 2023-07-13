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
        gnome.enable = true;
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