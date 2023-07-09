{ config, pkgs, lib, ... }:
{
  imports = [
    ./nginx.nix
    ./network.nix
    ./blocky.nix
    ./remoteunlock.nix
    # Important : podman or docker won't create the needed directorys or files
    ./containers/oci/jellyfin.nix
    ./containers/oci/postgresql-blocky.nix
  ];

    networking.networkmanager.enable = false;
    systemd.network.enable = true; 
    services.timesyncd.enable = true;
    systemd.network.wait-online.timeout = 30;
    networking.useDHCP = false;

    networking.firewall = {
        enable = true; # has to be enabled always or dns-crypt won't work
        interfaces = {
            br0.allowedTCPPorts = [ 
                80 443 # Nginx - on this side needed for DNS split
                8384 # Syncthing
                3000 # Grafana
                9090 # Prometheus
                22 # SSH
                10053 # Blocky
            ];
            br0.allowedUDPPorts = [ 
                10053 # Blocky
            ];
            wan0.allowedTCPPorts = [
                22 # SSH
                80 443 # Nginx
            ];
        };
        # because blocky fails basicly everytime i bind it to port 53, espically since i am using resolved simultaneously
        # i decided to redirect alle incomming traffic on port 53 to redirect to the open port 10053 that blocky is listening on
        # by doing so, resolved can be used as dns resolver for the local host and blocky for every other device on the local network
        extraCommands = ''
            iptables -t nat -s 10.0.0.1/24 -A PREROUTING -i br0 -p udp --dport 53 -j REDIRECT --to 10053
            iptables -t nat -s 10.0.0.1/24 -A OUTPUT  -p udp --dport 53 -j REDIRECT --to 10053
            iptables -t nat -s 10.0.0.1/24 -A PREROUTING -i br0 -p tcp --dport 53 -j REDIRECT --to 10053
            iptables -t nat -s 10.0.0.1/24 -A OUTPUT  -p tcp --dport 53 -j REDIRECT --to 10053
       '';
    }; 
            
}
