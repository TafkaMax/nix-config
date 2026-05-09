{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.dbeaver;
in
{
  options.${namespace}.apps.dbeaver = with types; {
    enable = mkBoolOpt false "Whether or not to enable Dbeaver.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dbeaver-bin ];
  };
}
