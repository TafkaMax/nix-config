{ options, config, pkgs, lib, ... }:

# NOTE - this 'zfs-storage' is regarding mountable zfs-storage, not root filesystem.
with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.hardware.zfs-storage;
in
{
  options.nixos-snowfall.hardware.zfs-storage = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable support for extra zfs-storage devices.";
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems.zfs = true;
  };
}
