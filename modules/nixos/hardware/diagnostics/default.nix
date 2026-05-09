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
  cfg = config.${namespace}.hardware.diagnostics;
in
{
  options.${namespace}.hardware.diagnostics = with types; {
    enable = mkBoolOpt false "Whether or not to enable diagnostics support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dmidecode
      gparted
    ];
  };
}
