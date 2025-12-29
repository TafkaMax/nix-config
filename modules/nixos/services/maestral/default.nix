{ options, config, pkgs, lib, namespace, ... }:

with lib;
with lib.${namespace};
let cfg = config.${namespace}.services.maestral;
in
{
  options.${namespace}.services.maestral = with types; {
    enable = mkBoolOpt false "Whether or not to configure maestral support.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ maestral maestral-gui ];
    systemd.user.services.maestral = {
      description = "Simple Daemon to start Maestral Dropbox sync service.";
      serviceConfig.Type = "exec";
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
    };
  };
}
