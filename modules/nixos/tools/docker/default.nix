{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.docker;
in
{
  options.${namespace}.tools.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable common docker utilities.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ docker-compose ]; };
}
