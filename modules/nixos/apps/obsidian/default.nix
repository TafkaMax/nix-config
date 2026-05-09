{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.obsidian;
in
{
  options.${namespace}.apps.obsidian = with types; {
    enable = mkBoolOpt false "Whether or not to enable Obsidian.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ obsidian ]; };
}
