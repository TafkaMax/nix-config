{ pkgs, config, lib, namespace, inputs, ... }:

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

  ${namespace} = {
    archetypes = {
      workstation = enabled;
    };
    # Set monitors.
    desktop.gnome = {
      monitors = ./monitors.xml;
    };


    user = {
      name = "tansper";
      email = "taavi.ansper@cyber.ee";
      initialPassword = config.age.secrets.tansper-3442-password.path;
      emailOptions = {
        settings = {
          "browser.search.countryCode" = "EE";
          "browser.search.region" = "EE";
          "browser.startup.homepage" = "https://wiki.cyber.ee";
        };
        username = "tansper";
        host = "mail1.cyber.ee";
        port = 993;
        type = "imap";
        auth_method = "normal password";
        signature = {
          text = ''
            ----
            Taavi Ansper
            taavi.ansper@cyber.ee
            +372 5905 2861
          '';
          showSignature = "append";
        };
        smtp = {
          host = "mail1.cyber.ee";
        };
      };
      mountpoints = lib.mkOptionDefault [
        "sftp://tansper@sysadm1.cyber.ee/home/tansper tansper on sysadm1.cyber.ee"
        "sftp://tansper@sysadm2.cyber.ee/home/tansper tansper on sysadm2.cyber.ee"
        "sftp://tansper@people.cyber.ee/home/tansper tansper on people.cyber.ee"
        "sftp://tansper@kola.cyber.ee/home/tansper tansper on kola.cyber.ee"
        "sftp://tansper@fs-int.cyber.ee/home/tansper tansper on fs-int.cyber.ee"
      ];
    };
  };

  # Enable vswitch for this host.
  virtualisation.vswitch.enable = true;
  virtualisation.vswitch.resetOnStart = false;

  # Enable both wirless and wired connection.
  # Set hostname.
  networking = {
    hostName = "tansper-3442";
    interfaces = {
      enp4s0 = {
        useDHCP = true;
      };
      eno1 = {
        useDHCP = false;
      };
      #veth0 = {
      #  virtual = true;
      #};
      #veth1 = {
      #  virtual = true;
      #};
      #br0 = {
      #  useDHCP = false;
      #  ipv4.addresses = [
      #    {
      #      address = "10.0.11.1";
      #      prefixLength = 24;
      #    }
      #  ];
      #  ipv4.routes = [
      #    {
      #      address = "10.0.11.0";
      #      prefixLength = 24;
      #      via = "10.0.11.1";
      #    }
      #  ];
      #};
    };


    # Vswitch doesn't work for some reason.
    #vswitches = {
    #  vs0 = {
    #    interfaces = {
    #      eno1 = {
    #        name = "eno1";
    #      };
    #      vs0 = {
    #        name = "vs0";
    #        type = "internal";
    #      };
    #      port1 = {
    #        name = "port1";
    #        type = "internal";
    #      };
    #      port2 = {
    #        name = "port2";
    #        type = "internal";
    #        vlan = 10;
    #      };
    #      port3 = {
    #        name = "port3";
    #        type = "internal";
    #        vlan = 10;
    #      };
    #      port4 = {
    #        name = "port4";
    #        type = "internal";
    #      };
    #    };
    #  };
    #};


    networkmanager = {
      dispatcherScripts = [{
        source = pkgs.writeText "99-disable-monitor-networking" ''
          #!/usr/bin/env ${pkgs.bash}/bin/bash

          if [ "$1" = "enp0s20f0u10u1" ]; then
            case "$2" in
              up) ${pkgs.networkmanager}/bin/nmcli connection down "Wired connection 2";
            esac
          fi
        '';
        type = "basic";
      }];
    };
  };
  # make dispatcher.d script executable by user.
  environment.etc."NetworkManager/dispatcher.d/03userscript0001".mode = lib.mkForce
    "0555";

  system.stateVersion = "24.05"; # Did you read the comment?
}
