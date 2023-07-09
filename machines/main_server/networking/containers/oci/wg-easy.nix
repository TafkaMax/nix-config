{ config, pkgs, lib, ... }:
let 
    configDir = "${config.setup.podman.dir}/wireguard-easy/data";
in
{

  virtualisation.oci-containers.containers.wg-easy = {
    environment = {
      # ⚠️ Required:
      # Change this to your host's public address
      WG_HOST="wireguard.pro7on.de";
      PASSWORD="${config.secrets.wg-easy.password}";
      WG_PORT="51820";
      WG_DEFAULT_DNS="9.9.9.9";
    };
    image = "docker.io/weejewel/wg-easy";
    volumes = [ "${configDir}:/etc/wireguard" ];
    ports = [ "51820:51820/udp" "127.0.0.1:51821:51821/tcp" ];
    autoStart = true;
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      "--cap-add=NET_RAW"
      ''--sysctl="net.ipv4.conf.all.src_valid_mark=1"''
      ''--sysctl="net.ipv4.ip_forward=1"''
    ];
  };

}     
