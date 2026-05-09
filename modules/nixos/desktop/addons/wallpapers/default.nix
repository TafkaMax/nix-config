{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  inherit (pkgs.${namespace}) wallpapers;
in
{
  options.${namespace}.desktop.addons.wallpapers = with types; {
    enable = mkBoolOpt false "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    ${namespace}.home.file = lib.foldl (
      acc: name:
      let
        wallpaper = wallpapers.${name};
      in
      acc
      // {
        "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper;
      }
    ) { } (wallpapers.names);
  };
}
