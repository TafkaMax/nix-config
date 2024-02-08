{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let
  cfg = config.nixos-snowfall.tools.libvirtd;
  user = config.nixos-snowfall.user;
in
{
  options.nixos-snowfall.tools.libvirtd = with types; {
    enable = mkBoolOpt false "Whether or not to enable libvirtd.";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    users.users.${user.name}.extraOptions = [ "qemu-libvirtd" "libvirtd" ];
  };
}
