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
  cfg = config.${namespace}.apps.zoom-us;
in
{
  options.${namespace}.apps.zoom-us = with types; {
    enable = mkBoolOpt false "Whether or not to enable zoom-us.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ zoom-us ]; };
}
