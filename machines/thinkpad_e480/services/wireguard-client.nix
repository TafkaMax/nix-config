{ lib, config, ...}:

{
  networking.wg-quick.interfaces = {
    home = {
      address = [
        "10.8.0.2/24"
      ];
      autostart = false;
      peers = [
        {
          allowedIPs = [
            "0.0.0.0/0" "::/0"
          ];
          presharedKey = "aaRYfeWwgjtin/GcAVBte1cSWWu703+UgG3LbpTkepU=";
          persistentKeepalive = 0;
          endpoint = "wireguard.pro7on.de:51820";
          publicKey = "zD1vDWNHfC9t7bxai3S4l9yufJSjIg2cJQvmkrU/lxM=";
        }
      ];
      privateKey = "${config.secrets.wg-quick.home.privateKey}";
      dns = [
        "9.9.9.9"
      ];
    };
  };
}
