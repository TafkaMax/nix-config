{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.suites.desktop;
in
{
  options.nixos-snowfall.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall = {
      desktop = {
        gnome = enabled;
        addons = { wallpapers = enabled; };
      };

      apps = {
        firefox = enabled;
        vlc = enabled;
        remmina = enabled;
      };

      tools = {
        flameshot = enabled;
      };
    };
  };
}
