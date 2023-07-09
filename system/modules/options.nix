{ config, lib, ... }:

{

  options = with lib; with lib.types; {

    setup = {
      
      hostname = mkOption { type = str; default = "thinkpad"; };
      keyboard = mkOption { type = str; default = "us";};
      screen = mkOption { type = enum [ "big" "small" ]; default = "small"; };
      
      mail.enable = mkEnableOption "Mail";
      bluetooth.enable = mkEnableOption "Bluetooth";
      dnscrypt.enable = mkEnableOption "DnsCrypt-Proxy";
      gui.enable = mkEnableOption "GUI";
      
      libvirt = {
        enable = mkEnableOption "libvirtd";
        autostart.enable = mkEnableOption "autostart libvirtd";
        ovmf.enable = mkEnableOption "omvf";
      };

      podman = {
        enable = mkEnableOption "Podman";
        dir = mkOption { type = str; default = "/home/snd/live"; };
      };

    };

  };
}
