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
    launchAtLogin = mkBoolOpt true "Whether to start the openlogi agent with graphical sessions.";
  };

  # Mirrors upstream packaging/linux/nixos-module.nix from https://github.com/AprilNEA/OpenLogi
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openlogi
    ];

    services.udev.packages = [ pkgs.openlogi ];

    systemd.user.services.openlogi-agent = {
      description = "OpenLogi background agent";
      wantedBy = optionals cfg.launchAtLogin [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = optionals cfg.launchAtLogin [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = getExe' pkgs.openlogi "openlogi-agent";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
