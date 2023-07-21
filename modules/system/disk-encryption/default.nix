{ options, config, pkgs, lib, ... }:
with lib;
with lib.internal;
let
  cfg = config.nixos-snowfall.system.disk-encryption;
in
{
  options.nixos-snowfall.system.disk-encryption = with types; {
    enable = mkBoolOpt false "Whether or not to enable networking support";
    hosts = mkOpt attrs { } "An attribute set to merge with <option>disk-encryption.hosts</option>";

  };
  # Enables 'common' disk encryption for hardware type of beat system. E.g similar setup as your ubuntu installer makes.
  # /dev/nvme0n1p1 = boot vfat
  # /dev/nvme0n1p2 = crypted disk that contains LVM and so on...
  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub = {
          enableCryptodisk = true;
          device = "nodev";
        };
      };
      initrd = {
        availableKernelModules = [
          "cryptd"
        ];
        luks.devices = {
          crypt = {
            preLVM = true;
          };
        };
      };
    };
  };
}
