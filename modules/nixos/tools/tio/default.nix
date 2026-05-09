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
  cfg = config.${namespace}.tools.tio;
in
{
  options.${namespace}.tools.tio = with types; {
    enable = mkBoolOpt false "Whether or not to enable common tio utilities.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ tio ]; };
}
