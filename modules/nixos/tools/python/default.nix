{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.python;
in
{
  options.nixos-snowfall.tools.python = with types; {
    enable = mkBoolOpt false "Whether or not to enable Python.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        (python311.withPackages (ps:
          with ps; [
            poetry
          ])
        )
      ];
    };
}
