{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.tools.virtualbox;
  user = config.nixos-snowfall.user;
in
{
  options.nixos-snowfall.tools.virtualbox = with types; {
    enable = mkBoolOpt false "Whether or not to enable virtualbox.";
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "${user.name}" ];
  };
}
