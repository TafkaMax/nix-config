{ config, lib, ... }:
let 
  dir = "/etc/wireguard";
  source = "/home/snd/live/wireguard";
in
{

  # IMPORTANT
  # Systemd-network needs to be able to read every file. However, i wasn't able to find the right permissions online and therfore i have wrote the following..
  # But the solution turned to be : systemd-network:root
  # So how can i create the right files with the right permissions?
  # Option 1: just make shure that the target directory and every file in there is owned by systemd-network with the group root and persmission 0600
  # Option 2: run the script 2 times, because the needed files will be created after systemd-network tries to setup the interface
  environment.etc = {
    
    "wireguard/server_private.key" = {
      user = config.users.users.systemd-network.name;
      mode = "0600";
      source = "${source}/server_private.key"; 
    };

    "wireguard/presharedkeys/smartphone.key" = {
      user = config.users.users.systemd-network.name;
      mode = "0600";
      source = "${source}/presharedkeys/smartphone.key"; 
    };

  };

  # How generate the keys ?
  # wg genkey | tee privatekey | wg pubkey > publickey

  systemd.network.netdevs."20-wg0" = {
    
    netdevConfig = {
      Name = "wg0";
      Kind = "wireguard";
      Description = "Wireguard Server";
    };

    wireguardConfig = {
      PrivateKeyFile = "${dir}/server_private.key";
      ListenPort = 51820;
    };

    wireguardPeers = [

      # Smartphone
      { wireguardPeerConfig = {
          AllowedIPs = [ "10.0.10.2/24" ];
          Endpoint = "wireguard.pro7on.de:51820";
          PresharedKeyFile = "${dir}/presharedkeys/smartphone.key";
          PublicKey = "UgsLuiq540QkahX3sdLzOV4GT9hrGNKdhGNUTjvlNAQ=";
          PersistentKeepalive = 25;
        };
      }

    ];

  };

  systemd.network.networks."30-wg0" = {

    matchConfig = {
      Name = "wg0";
    };

    networkConfig = {
      Address = "10.0.10.1/24";
      DNS = "9.9.9.9";
      ConfigureWithoutCarrier = "yes";
      IgnoreCarrierLoss = "yes";
      IPForward = "ipv4";
    };

  };

  # If no external communication is necessary, then this option should be commented out
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.firewall = {
    trustedInterfaces = [ "wg0" ];
    interfaces.wg0.allowedUDPPorts = [ 51820 53 ];
    interfaces.wan0.allowedUDPPorts = [ 51820 ];
  };

  # Don't foget to add the needed rules to resolved local domains (see nginx.nix)

}
