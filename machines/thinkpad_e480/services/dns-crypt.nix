{ lib, config, pkgs, ...}:
lib.mkIf config.setup.dnscrypt.enable {

  networking.nameservers = [ "::1" ];

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = [ "[::1]:51" ];
      bootstrap_resolvers = [
        "9.9.9.9:53"
      ];
      sources.quad9-resolvers = {
        urls = ["https://www.quad9.net/quad9-resolvers.md"];
        minisign_key = "RWQBphd2+f6eiAqBsvDZEBXBGHQBJfeG6G+wJPPKxCZMoEQYpmoysKUN";
        cache_file = "quad9-resolvers.md";
        prefix = "quad9-";
      };
    };
  };

  networking.firewall.extraCommands = ''
    ip6tables --table nat --flush OUTPUT
    ${lib.flip (lib.concatMapStringsSep "\n") [ "udp" "tcp" ] (proto: ''
      ip6tables --table nat --append OUTPUT \
        --protocol ${proto} --destination ::1 --destination-port 53 \
        --jump REDIRECT --to-ports 51
    '')}
  '';
}
