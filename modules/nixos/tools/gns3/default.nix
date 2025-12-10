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
    # Add gns3-server using the old way for now.
    environment.systemPackages = with pkgs; [ gns3-server ubridge ];
    users.groups.ubridge = { };
    users.users.${user.name}.extraGroups = [ "ubridge" ];
    security.wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "ubridge";
      permissions = "u+rx,g+rx,o+rx";
    };

    # TODO don't currently add this.
    # Add gns3-server as service.
    #services.gns3-server = {
    #  enable = true;
    #  ubridge = {
    #    enable = true;
    #  };
    #  auth = {
    #    enable = true;
    #    user = "gns3";
    #    passwordFile = "/etc/nixos/modules/nixos/tools/gns3/gns3_password.txt";
    #  };
    #};
    ## Add current user to ubridge group.
    #users.users.${user.name}.extraGroups = [ "ubridge" ];
  };
}
