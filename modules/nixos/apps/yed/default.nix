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
  cfg = config.${namespace}.apps.yed;
in
{
  options.${namespace}.apps.yed = with types; {
    enable = mkBoolOpt false "Whether or not to enable yed.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ yed ]; };
}
