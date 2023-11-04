{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.desktop.addons.wallpapers;
  inherit (pkgs.nixos-snowfall) wallpapers;
in
{
  options.nixos-snowfall.desktop.addons.wallpapers = with types; {
    enable = mkBoolOpt false
      "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    nixos-snowfall.home.file = lib.foldl
      (acc: name:
        let wallpaper = wallpapers.${name};
        in
        acc // {
          "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper;
        })
      { }
      (wallpapers.names);
  };
}
