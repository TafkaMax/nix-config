{ config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.logiops;
in
{
  options.${namespace}.tools.logiops = with types; {
    enable = mkBoolOpt false "Whether or not to enable logiops.";
    renice = lib.mkOption {
      description = "Set the nice value of the process";
      default = true;
    };
    reniceValue = lib.mkOption {
      description = "Set the nice value of the process";
      default = -19;
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      logiops
    ];

    # https://github.com/PixlOne/logiops/blob/main/TESTED.md
    # https://github.com/PixlOne/logiops/issues/116#issuecomment-1583041962
    # https://github.com/PixlOne/logiops/issues/248
    systemd.services.logiops = {
      description = "An unofficial userspace driver for HID++ Logitech devices";
      wantedBy = [ "default.target" ];
      serviceConfig =
        let
          logiopsConfig = pkgs.writeText "logiops.cfg" ''
            devices: (
            {
              name: "MX Master 3S";
              dpi: 800;
              hiresscroll: {
                hires: true;
                invert: false;
                target: true;
            	  up: {
                  mode: "Axis";
                  axis: "REL_WHEEL";
                  axis_multiplier: 1.0;
                },
              	down: {
                  mode: "Axis";
                  axis: "REL_WHEEL";
                  axis_multiplier: -1.0;
              	}
              };
              smartshift: {
                on: true;
                threshold: 150;
                default_threshold: 150;
              };
            }
            );
          '';
        in
        {
          Type = "simple";
          ExecStart =
            let
              renice = lib.optionalString cfg.renice "${pkgs.coreutils-full}/bin/nice -n ${builtins.toString cfg.reniceValue}";
            in
            "${renice} ${pkgs.logiops}/bin/logid -c ${logiopsConfig}";
        };
    };

  };
}