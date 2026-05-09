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
  cfg = config.${namespace}.tools.libvirtd;
  user = config.${namespace}.user;
in
{
  options.${namespace}.tools.libvirtd = with types; {
    enable = mkBoolOpt false "Whether or not to enable libvirtd.";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    users.users.${user.name}.extraGroups = [
      "qemu-libvirtd"
      "libvirtd"
    ];
    environment.systemPackages = with pkgs; [ qemu-utils ];
  };
}
