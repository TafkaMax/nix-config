{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-amd
    common-gpu-amd
    common-pc
    common-pc-ssd
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];

    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.crypt.device = "/dev/nvme0n1p2";
    };
    extraModulePackages = [ ];
    zfs.extraPools = [ "tafka-storage" ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];
}
