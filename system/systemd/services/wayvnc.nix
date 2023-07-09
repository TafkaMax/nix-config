{ lib, config, ...}:
{
  systemd.services.wayvnc = {
    enable = true;
    
    description = "wayvnc to use tablet as monitor - unencrypted";
    after = [ "network.target" ];
    startLimitIntervalSec = 0;

    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
      WAYLAND_DISPLAY = "wayland-1";
    };
    serviceConfig = {
      User = "snd";
      Type = "simple";
    };
    script = "wayvnc 0.0.0.0 username=snd password=sonne -f 60";
    
    #wantedBy = [ "multi-user.target" ];
  };
}
