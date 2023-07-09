{ config, lib, pkgs, ... }:
let
  cfg = config.setup.qbittorrent;
in
{
  options.setup.qbittorrent = {
    enable = lib.mkEnableOption "the qbittorrent service";
    homeDir = lib.mkOption { type = lib.types.path; default = "/var/lib/qbittorrent"; };
    configDir = lib.mkOption { type = lib.types.path; default = "${cfg.homeDir}/config"; };
    downloadDir = lib.mkOption { type = lib.types.path; default = "${cfg.homeDir}/download"; };
    webuiPort = lib.mkOption { type = lib.types.int; default = 8099; };
    fqdn = lib.mkOption { type = lib.types.str; default = "torrent.pro7on.de"; };
    wg-dns = lib.mkOption { type = lib.types.str; default = "100.64.0.2"; };
  };

  config = {

    users.users.snd.extraGroups = [ "qbittorrent" ];
    
    users.users.qbittorrent = {
      group = "qbittorrent";
      home = cfg.homeDir;
      isSystemUser = true;
    };
    users.groups.qbittorrent = { };

    systemd.tmpfiles.rules = [
      "d '${cfg.downloadDir}' 0775 qbittorrent users - -"
      "d '${cfg.homeDir}' 0771 qbittorrent qbittorrent - -"
    ];

    networking.wireguard.interfaces.wg-qbittorrent = {
      
      privateKey = config.secrets.wg-quick.torrenting.privateKey;
      ips = [ "10.68.41.97/32" "fc00:bbbb:bbbb:bb01::5:2960/128" ];
      
      peers = [ {
        publicKey = "DVui+5aifNFRIVDjH3v2y+dQ+uwI+HFZOd21ajbEpBo="; 
        allowedIPs = [ "0.0.0.0/0" "::0/0" ];
        endpoint = "185.65.134.82:51820";
      } ];
      
      interfaceNamespace = "qbittorrent";
      preSetup = "ip netns add qbittorrent && ip -n qbittorrent link set lo up";
      postShutdown = "ip netns del qbittorrent";
    
    };

    environment.etc."netns/qbittorrent/resolv.conf".text = ''
      nameserver ${config.setup.qbittorrent.wg-dns} 
    '';

    systemd.services.qbittorrent = {
    
      description = "qBittorrent Service";
      after = [ "wireguard-wg-qbittorrent.service" ];
      requires = [ "wireguard-wg-qbittorrent.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        
        PrivateNetwork = true;
        NetworkNamespacePath = "/run/netns/qbittorrent";

        Restart = "always";
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=${cfg.configDir} --webui-port=${toString cfg.webuiPort}";
        User = "qbittorrent";
        Group = "qbittorrent";

        # Increase number of open file descriptors (default: 1024)
        LimitNOFILE = 65536;

        # systemd-analyze --no-pager security qbittorrent.service
        CapabilityBoundingSet = null;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectHome = true;
        RestrictNamespaces = true;
        SystemCallFilter = "@system-service";
      
      };

    };

    systemd.services.qbittorrent-webui-proxy = {
      
      wantedBy = [ "multi-user.target" ];
      after = [ "wireguard-wg-qbittorrent.service" ];
      partOf = [ "wireguard-wg-qbittorrent.service" ];

      serviceConfig = {
      
        PrivateNetwork = true;
        NetworkNamespacePath = "/run/netns/qbittorrent";

        Restart = "always";
        ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:${cfg.homeDir}/webui.sock,fork,reuseaddr,mode=660,unlink-early TCP:127.0.0.1:${toString cfg.webuiPort}";
        User = "qbittorrent";
        Group = "nginx";

        # systemd-analyze --no-pager security qbittorrent-webui-proxy.service
        CapabilityBoundingSet = null;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectHome = true;
        RestrictNamespaces = true;
        SystemCallFilter = "@system-service";
      
      };
    
    };

    services.nginx.virtualHosts."${cfg.fqdn}" = {
      enableACME = lib.mkDefault true;
      forceSSL = lib.mkDefault true;
      # treated as state
      basicAuthFile = "${cfg.homeDir}/htpasswd";
      locations = {
        "/" = {
          proxyPass = "http://unix:${cfg.homeDir}/webui.sock";
          proxyWebsockets = true;
        };
        "/download/" = {
          alias = "${cfg.downloadDir}/";
          extraConfig = ''
            autoindex on;
          '';
        };
      };
    };
  };
}

