{ pkgs, config, lib, channel, inputs, ... }:

with lib;
with lib.nixos-snowfall;
{
  imports = [ ./hardware-configuration.nix ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  nixos-snowfall = {
    archetypes = {
      gaming = enabled;
    };
    # Set monitors.
    desktop.gnome = {
      monitors = ./monitors.xml;
    };


    user = {
      initialPassword = config.age.secrets.tafka-e495-password.path;
    };
  };

  # Enable both wirless and wired connection.
  # Set hostname.
  networking = {
    hostName = "tafka-e495";
    interfaces = {
      enp2s0 = {
        useDHCP = true;
      };
      wlp4s0 = {
        useDHCP = true;
      };
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
