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
  cfg = config.${namespace}.tools.openlogi;
in
{
  options.${namespace}.tools.openlogi = with types; {
    enable = mkBoolOpt false "Whether or not to enable openlogi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openlogi
    ];

  };
}
