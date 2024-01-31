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
    environment.systemPackages = with pkgs; [ gns3-server ];
    users.users.${user.name} = {
      packages = with pkgs; [
        gns3-gui
      ];
    };
  };
}
