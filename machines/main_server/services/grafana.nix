{ config, lib, pkgs, ... }:
let
    # i have to store the password in a file to avoid the following promt (it is not an error - it is just annoying)
    # trace: warning: Declarations in the `secureJsonData`-block of a datasource will be leaked to the
    # Nix store unless a file-provider or an env-var is used!
    passwordFile = builtins.toFile "sqlpassword" ''
        blocky
    '';
in
{
    environment.systemPackages = with pkgs; [
        grafanaDashboardsConfig
    ];

    services.grafana = {
        enable = true;
        settings = {
            sercurity = {
                admin_password = "${config.secrets.grafana.adminPass}";
            };
            server = {
                domain = "grafana.pro7on.de";
                http_addr = "0.0.0.0";
                http_port = 3000;
            };
        };
        provision = {
            datasources.settings.datasources = [ 
                {name = "main_server"; url = "http://127.0.0.1:9090"; type = "prometheus"; } 
                {
                    name = "main_server_postgresql_blocky"; 
                    url = "127.0.0.1:15432"; 
                    type = "postgres";
                    user = "blocky";
                    secureJsonData.password = "$__file{${passwordFile}}";
                    jsonData = { database = "blocks"; sslmode = "disable"; };
                } 
            ];
            dashboards = {
                settings = {
                    providers = [
                        { name = "My Dashboards"; options.path = "${pkgs.grafanaDashboardsConfig}"; }
                    ];
                };
            };
        };
    };
}
