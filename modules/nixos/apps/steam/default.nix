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
      };
      gamescope = {
        enable = true;
        enableWsi = true;
        capSysNice = false;
      };
    };

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      steam
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}
