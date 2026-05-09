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
  cfg = config.${namespace}.security.keepassxc;
in
{
  options.${namespace}.security.keepassxc = with types; {
    enable = mkBoolOpt false "Whether to enable keepassxc.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
