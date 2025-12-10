{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.wireshark;
in
{
  options.nixos-snowfall.tools.wireshark = with types; {
    enable = mkBoolOpt false "Whether or not to enable common wireshark utilities.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ wireshark ]; };
}
