{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.sshfs;
in
{
  options.nixos-snowfall.tools.sshfs = with types; {
    enable = mkBoolOpt false "Whether or not to enable sshfs-fuse utility.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ sshfs-fuse ]; };
}
