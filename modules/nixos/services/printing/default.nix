{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.printing;
in
{
  options.${namespace}.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-kyocera
        cups-kyocera-3500-4500
        cups-kyocera-ecosys-m552x-p502x
        hplip
      ];
    };
#environment.systemPackages = with pkgs; [
#      ptouch-print
#      cups-kyocera
#      cups-kyocera-ecosys-m552x-p502x
#      hplip
#      foomatic-db-ppds
#      cups-kyodialog
#    ];
  };
}
