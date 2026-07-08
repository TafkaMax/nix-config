{
  config,
  lib,
  namespace,
  ...
}:

# NOTE - this 'zfs-storage' is regarding mountable zfs-storage, not root filesystem.
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.zfs-storage;
in
{
  options.${namespace}.hardware.zfs-storage = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for extra zfs-storage devices.";
  };

  config = mkIf cfg.enable {
    boot = {
      supportedFilesystems.zfs = true;
      zfs.forceImportRoot = false;
    };
  };
}
