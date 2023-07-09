{ config, pkgs, lib, ... }:
let 
    dbDir = "${config.setup.podman.dir}/postgresql-blocky/db";
in
{

  virtualisation.oci-containers.containers.postgresqlBlocky = {
    image = "docker.io/library/postgres:15.2-alpine";
    user = "1000:100";
    ports = [ "127.0.0.1:15432:5432" ];
    environment = {
        POSTGRES_USER = "blocky";
        POSTGRES_PASSWORD = "blocky";
        POSTGRES_DB = "blocks";
    };
    volumes = [
      "${dbDir}:/var/lib/postgresql/data"
    ];
    autoStart = true;
  };

}
