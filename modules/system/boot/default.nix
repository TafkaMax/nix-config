{ options, config, pkgs, lib, ... }:

with lib;
with lib.internal;
let cfg = config.nixos-snowfall.system.boot;
in
{
  options.nixos-snowfall.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
  };

  config = mkIf cfg.enable {
    # TODO enable systemd boot
    boot.loader.systemd-boot.enable = false;
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          useOSProber = true;
          enable = true;
          efiSupport = true;
          configurationLimit = 10;
        };
      };
    };

    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    #boot.loader.systemd-boot.editor = false;
    #boot.loader.systemd-boot.configurationLimit = 5;
  };
}
