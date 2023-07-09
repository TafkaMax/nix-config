{ config, pkgs, lib, ... }:
let 
    configDir = "${config.setup.podman.dir}/jellyfin/config";
    mediaDir = "/home/snd/media";
in
{

  virtualisation.oci-containers.containers.jellyfin = {
    image = "docker.io/jellyfin/jellyfin";
    user = "1000:100";
    ports = [ "127.0.0.1:8096:8096" ];
    volumes = [
      "${configDir}:/config"
      "${mediaDir}:/media2:ro"
    ];
    autoStart = true;
  };

}
