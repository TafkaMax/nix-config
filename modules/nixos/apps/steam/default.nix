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
  cfg = config.${namespace}.apps.steam;
in
{
  options.${namespace}.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamescope = {
        enable = true;
        capSysNice = false;
      };
      gamemode = {
        enable = true;
      };
    };

    hardware.steam-hardware.enable = true;
  };
}
