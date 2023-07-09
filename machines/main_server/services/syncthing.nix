{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    user = "nas";
    group = "users";
    overrideFolders = true;
    overrideDevices = true;
    guiAddress = "0.0.0.0:8384"; 
    extraOptions =  {
      gui = {
        theme = "black";
        insecureAdminAccess = true;
      };
      options = {
        localAnnounceEnabled = false;
      };
    };
    configDir = "/home/nas/.config/syncthing"; # required
    folders = {
      audiobooks = {
        enable = true;
        type = "sendonly";
        path = "~/audio/audiobooks";
        devices = [ "thinkpad" "desktop" "tabS6Lite" "oneplus8t" ];
      };
    };
    devices = {
      thinkpad = { id = "INWJ2EP-Q2UB5L2-VZBYR2O-FWKL3UI-OA3IBSK-S6C5DQ5-J2RBCSM-IEQN2QV"; };
      desktop = { id = "PK2RGHG-ML6H4PX-AXMJJZT-TYDDN3H-FCY6IOR-SBWHKTM-JXMJWD3-L6ZQRQJ"; };
      tabS6Lite = { id = "TVRFQYN-45CMEGF-2Y3WVIC-WIQBPPC-QCEWYJP-FHVLSBV-OIECAIW-3G25YQE"; };
      oneplus8t = { id = "M242EDJ-YW4VK3X-VUHJCPD-WVZ7CHH-YKAY2DE-NAFXNUW-U3QMR27-UEH6CAL"; };
    };
  };
}
