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
  cfg = config.${namespace}.security.openconnect;
in
{
  options.${namespace}.security.openconnect = with types; {
    enable = mkBoolOpt false "Whether or not to enable openconnect";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openconnect
      networkmanager-openconnect
    ];
  };
}
