{ config, ... } @ args:

{
  imports = [
    # Include custom variables.
    ../../variables/variables.nix
    ./variables.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/core-desktop.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/user-group.nix
    ../../modules/nixos/terminal.nix
  ];

  #import overlays
  nixpkgs.overlays = import ../../overlays args;

  # Change this value to point to a storage device where the root partition will live.
  # eg. /dev/nvme0n1p2
  boot.initrd.luks.devices.crypt.device = "/dev/nvme0n1p2";

  networking = {
    hostName = "tansper-3106";
    networkmanager.enable = true;
    interfaces = {
      enp0s31f6 = {
        useDHCP = true;
      };
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
