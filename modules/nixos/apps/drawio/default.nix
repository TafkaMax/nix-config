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
  cfg = config.${namespace}.apps.drawio;
in
{
  options.${namespace}.apps.drawio = with types; {
    enable = mkBoolOpt false "Whether or not to enable Draw IO.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ drawio ];
  };
}
