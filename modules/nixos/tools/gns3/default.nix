{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.tools.gns3;
  user = config.nixos-snowfall.user;
in
{
  options.nixos-snowfall.tools.gns3 = with types; {
    enable = mkBoolOpt false "Whether or not to enable common gns3 utilities.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.home.extraOptions = {
      home.packages = with pkgs; [
        gns3-gui
      ];
    };
    # Add gns3-server as service.
    services.gns3-server = {
      enable = true;
      ubridge = {
        enable = true;
      };
      auth = {
        enable = true;
        username = "gns3";
        passwordFile = "/etc/nixos/modules/nixos/tools/gns3/gns3_password.txt";
      };
    };
  };
}
