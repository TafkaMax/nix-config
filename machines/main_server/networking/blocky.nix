{ config, lib, ... }:
{
    services.blocky = {
        enable = true;
        settings = {
            upstream = {
                default = [
                    "https://dns.digitale-gesellschaft.ch/dns-query"
                    "https://dns.quad9.net/dns-query"
                ];
            };
            bootstrapDns = { upstream = "tcp+udp:9.9.9.9"; };
            caching = {
                minTime = "5m";
                maxTime = "30m";
                prefetching = true;
            };
            port = 10053;
            httpPort = 4000;
            prometheus = {
                enable = true;
                path = "/metrics";
            };
            blocking = {
                blackLists = {
                    ads = [
                        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
                        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                    ];
                    # my tp link ap request constant the same domains
                    tpLink = [
                        ''
                        |
                        /amazon.com/
                        /wikipedia.org/
                        ''
                    ];
                };
                clientGroupsBlock = {
                    # TP LInk
                    "10.0.0.114" = [ "tpLink" ];
                    default = [ "ads" ];
                };
            };
            customDNS = {
                rewrite = {
                    "jellyfin.pro7on.de" = "main-server.lan";
                };
                mapping = {
                    "main-server.lan" = "10.0.0.1";
                };
            };
            queryLog = {
                type = "postgresql";
                logRetentionDays = 7;
                target = "postgresql://blocky:blocky@localhost:15432/blocks";
            };
        };
    };

    systemd.services.blocky = {
        preStart = "sleep 20"; # is required, because blocky request bootstrapDns faster then sytemd-networkd is completly ready"
        after = [ "systemd-networkd.service" "podman-postgresqlBlocky.service" ];
        requires = [ "systemd-networkd.service" ];
    }; 
}
