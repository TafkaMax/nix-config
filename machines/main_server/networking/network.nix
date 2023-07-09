# wait-online needs at least one interface that is not "no-carrier"
{ config, lib, ... }:
{
    systemd.network = {
        
        # Rename Network Interfaces 
        links = {
            "10-lan0" = {
                matchConfig = { MACAddress = "d8:5e:d3:de:71:a9"; };
                linkConfig = { Name = "lan0"; };
            };
            "10-wan0" = {
                matchConfig = { MACAddress = "34:60:f9:bb:47:27"; };
                linkConfig = { Name = "wan0"; };
            };
        };

        netdevs = {
            # Define Bridge Interface
            "20-br0" = {
                netdevConfig = {
                    Name = "br0";
                    Kind = "bridge";
                };
            };
        };

        networks = {
            # WAN Network
            "30-wan0" = {
                name = "wan0";
                DHCP = "ipv4"; 
                dhcpV4Config = {
                    UseDNS = "no";
                };
            };
            # Bond br0 to an interface
            "30-lan0" = {
                linkConfig.RequiredForOnline = "no"; # fix me: remove me in production
                bridge = [ "br0" ];
                name = "lan0";
            };
            # Define Bridge Network + DHCP
            "30-br0" = {
                linkConfig = {
                    RequiredForOnline = "no";
                    #ActivationPolicy = "always-up";
                };
                name = "br0";
                domains = [ "pro7on.de" ];
                address = [ "10.0.0.1/24" ];
                dns = [ "9.9.9.9" ]; # arch wiki: systemd-resolved is required if DNS entries are specified in .network files
                networkConfig = {
                    DHCPServer = "yes";
                    ConfigureWithoutCarrier = "yes"; # wait-online will fail still without setting RequiredForOnline to no
                    IPv6AcceptRA = "no";
                    IPv6SendRA = "no";
                    IgnoreCarrierLoss = "yes"; # not the same as ConfigureWithoutCarrier
                };
                dhcpServerConfig = {
                    DNS = "_server_address";
                    EmitDNS = "yes";
                    EmitRouter = "yes";
                };
                dhcpServerStaticLeases = [
                    # Switch
                    {dhcpServerStaticLeaseConfig = { Address = "10.0.0.2"; MACAddress = "0C:97:5F:63:F9:A0"; };}
                ];
            };
        };
    };
    
    boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
    };

    networking.nat = {
        enable = true;
        externalInterface = "wan0";
        internalInterfaces = [ "br0" ];
        internalIPs = config.systemd.network.networks."30-br0".address;
    };

    # resolved is enabled to insure full network capability
    # i recomend to keep resovled enabled even if there is another dns running on this host
    services.resolved = {
        enable = true;
        fallbackDns = [ "9.9.9.9" ];
    };

    networking.firewall.interfaces.br0.allowedUDPPorts = [ 53 67 ];
    networking.firewall.interfaces.br0.allowedTCPPorts = [ 53 ];

}
