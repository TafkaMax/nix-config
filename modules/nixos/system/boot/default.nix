{ options, config, pkgs, lib, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.system.boot;
in
{
  options.nixos-snowfall.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        # TODO enable systemd boot
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
        grub = {
          useOSProber = true;
          enable = true;
          efiSupport = true;
          configurationLimit = 10;
          # add this so efi is installed at path /efi/boot/bootx64.efi instead of /efi/NixOS-boot/grubx64.efi. So when doing BIOS updates it is found.
          efiInstallAsRemovable = true;
        };
      };
    };

    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    #boot.loader.systemd-boot.editor = false;
    #boot.loader.systemd-boot.configurationLimit = 5;
  };
}
