{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.apache-directory-studio;
in
{
  options.nixos-snowfall.tools.apache-directory-studio = with types; {
    enable = mkBoolOpt false "Whether or not to enable apache-directory-studio.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ apache-directory-studio ]; };
}
