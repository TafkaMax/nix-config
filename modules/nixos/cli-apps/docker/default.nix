inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.cli-apps.docker;
  user = config.nixos-snowfall.user;
in
{
  options.nixos-snowfall.cli-apps.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable docker.";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${user.name}.extraGroups = [ "docker" ];
  };
}
