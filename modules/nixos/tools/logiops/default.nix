{ config, lib, pkgs, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.logiops;
in
{
  options.${namespace}.tools.logiops = with types; {
    enable = mkBoolOpt false "Whether or not to enable logiops.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      logiops
    ];

  };
}