{ options, config, lib, namespace, pkgs, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.davinci-resolve;
in
{
  options.${namespace}.apps.davinci-resolve = with types; {
    enable = mkBoolOpt false "Whether or not to enable Davinci Resolve.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ davinci-resolve ];
  };
}