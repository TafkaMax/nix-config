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
  cfg = config.${namespace}.tools.gnumake;
in
{
  options.${namespace}.tools.gnumake = with types; {
    enable = mkBoolOpt false "Whether or not to enable common gnumake utilities.";
  };

  config = mkIf cfg.enable {
    ${namespace}.home.extraOptions = {

      home.packages = with pkgs; [
        # DO NOT install build tools for C/C++, set it per project by devShell instead
        gnumake # used by this repo, to simplify the deployment
        clang-tools
        clang-analyzer
      ];
    };
  };
}
