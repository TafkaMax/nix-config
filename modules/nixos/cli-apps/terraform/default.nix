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
  cfg = config.${namespace}.cli-apps.terraform;
in
{
  options.${namespace}.cli-apps.terraform = with types; {
    enable = mkBoolOpt false "Whether or not to enable terraform.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      terraform
    ];

  };
}
