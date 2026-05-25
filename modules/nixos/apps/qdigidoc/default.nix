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
  cfg = config.${namespace}.apps.qdigidoc;
in
{
  options.${namespace}.apps.qdigidoc = with types; {
    enable = mkBoolOpt false "Whether or not to enable qdigidoc for Estonian ID card functionality.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ qdigidoc libdigidocpp opensc p11-kit ];
  };
}
