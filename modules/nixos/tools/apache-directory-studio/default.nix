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
  cfg = config.${namespace}.tools.apache-directory-studio;
in
{
  options.${namespace}.tools.apache-directory-studio = with types; {
    enable = mkBoolOpt false "Whether or not to enable apache-directory-studio.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ apache-directory-studio ]; };
}
