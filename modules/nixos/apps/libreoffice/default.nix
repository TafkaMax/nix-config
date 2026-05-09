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
  cfg = config.${namespace}.apps.libreoffice;
in
{
  options.${namespace}.apps.libreoffice = with types; {
    enable = mkBoolOpt false "Whether or not to enable Libreoffice.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libreoffice ];
  };
}
