{ config, lib, pkgs, ... }:
{
  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "0";
    GDK_BACKEND = "wayland";
    GTK_THEME = config.home-manager.users.snd.gtk.theme.name;
    STARSHIP_CONFIG = "~/.config/starship/starship.toml";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
