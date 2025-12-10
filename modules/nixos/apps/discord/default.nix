{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.apps.discord;
in
{
  options.nixos-snowfall.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ discord ];
  };
}
