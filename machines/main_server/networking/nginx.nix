{ lib, config, ... }:
{
    services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        statusPage = true; # needs to be enabled for nginx exporter to work
        virtualHosts = {
            "grafana.pro7on.de" =  {
                enableACME = true;
                forceSSL = true;
                locations."/".proxyPass = "http://127.0.0.1:3000";
            };
            "wireguard.pro7on.de" =  {
                enableACME = true;
                forceSSL = true;
                locations."/".proxyPass = "http://127.0.0.1:51821";
            };
            "jellyfin.pro7on.de" =  {
                enableACME = true;
                forceSSL = true;
                locations."/".proxyPass = "http://127.0.0.1:8096";
            };
            "syncthing.pro7on.de" =  {
                enableACME = true;
                forceSSL = true;
                locations."/".proxyPass = "http://127.0.0.1:8384";
                extraConfig = ''
                    allow 10.0.0.0/24;
                    allow 10.0.10.0/24;
                    deny all;
                ''; # 10.0.10.0 : Subnet of my wireguard VPN
            };
        };
    };

    security.acme = {
        defaults.email = "${config.secrets.acme.email}";
        acceptTerms = true;
    };
}
