{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.nixos-snowfall.tools.gnumake;
in
{
  options.nixos-snowfall.tools.gnumake = with types; {
    enable = mkBoolOpt false "Whether or not to enable common gnumake utilities.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        # DO NOT install build tools for C/C++, set it per project by devShell instead
        gnumake # used by this repo, to simplify the deployment
        clangtools
        clang-analyzer
      ];
    };
}
