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
  cfg = config.${namespace}.apps.nexusmods-app;
in
{
  options.${namespace}.apps.nexusmods-app = with types; {
    enable = mkBoolOpt false "Whether or not to enable NexusMods.app for gaming.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nexusmods-app-unfree ];
  };
}
