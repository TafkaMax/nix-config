{ config, lib, ... }:
{
    services.prometheus = {
        enable = true;
        port = 9090;
        listenAddress = "0.0.0.0";
        scrapeConfigs = [
            { job_name = "smartctl"; static_configs = [ { targets = [ "127.0.0.1:9633" ]; } ]; }
            { job_name = "blocky"; static_configs = [ { targets = [ "127.0.0.1:4000" ]; } ]; }
            { job_name = "node"; static_configs = [ { targets = [ "127.0.0.1:9533" ]; } ]; }
            { job_name = "nginx"; static_configs = [ { targets = [ "127.0.0.1:9433" ]; } ]; }
        ];
        exporters = {
            smartctl = {
                enable = true;
                port = 9633;
            };
            node = {
                enable = true;
                port = 9533;
            };
            nginx = {
                enable = true;
                port = 9433;
            };
        };
    };
}
