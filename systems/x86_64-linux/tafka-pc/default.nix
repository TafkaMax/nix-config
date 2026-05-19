{
  config,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
{
  imports = [ ./hardware-configuration.nix ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVLOcHkl+JETafiovKefivFPh7soFZ2KUBSMicWsDV6 root@tafka-pc";
    };
  };

  ${namespace} = {

    hardware.zfs-storage.enable = true;
    hardware.corectrl.enable = true;

    archetypes = {
      gaming = enabled;
    };
    # Set monitors.
    desktop.gnome = {
      monitors = ./monitors.xml;
    };

    user = {
      initialPassword = config.age.secrets.tafka-pc-password.path;
    };
  };

  # Enable both wirless and wired connection.
  # Set hostname.
  networking = {
    hostName = "tafka-pc";
    interfaces = {
      enp6s0 = {
        useDHCP = true;
      };
    };
    hostId = "105f5fe0";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
