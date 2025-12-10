{ options, config, lib, namespace, pkgs, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.gamja;
in
{
  options.${namespace}.apps.gamja = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gamja IRC client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gamja ];
  };
}