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
  cfg = config.${namespace}.tools.misc-work;
in
{
  options.${namespace}.tools.misc-work = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities for work PC.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lldpd
    ];
    services.lldpd.enable = true;
  };
}
