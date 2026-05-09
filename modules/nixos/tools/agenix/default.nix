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
  cfg = config.${namespace}.tools.agenix;
in
{
  options.${namespace}.tools.agenix = with types; {
    enable = mkBoolOpt false "Whether or not to enable agenix.";
  };

  config = mkIf cfg.enable {
    ${namespace}.home.extraOptions = {
      home.packages = with pkgs; [
        agenix
      ];
    };
  };
}
