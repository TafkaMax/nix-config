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
    environment.systemPackages = with pkgs; [ gns3-server ubridge ];
    nixos-snowfall.home.extraOptions = {
      home.packages = with pkgs; [
        gns3-gui
      ];
    };
    # Add ubridge
    users.groups.ubridge = { };
    users.users.${user.name}.extraGroups = [ "ubridge" ];
    security.wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_admin,cap_net_raw=ep";
      owner = "root";
      group = "ubridge";
      permissions = "u+rx,g+rx,o+rx";
    };
  };
}
