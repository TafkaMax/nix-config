{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    user = "snd";
    #systemService = false; # TODO
    # needs to be enabled or syncthing-init will fail
    # https://github.com/NixOS/nixpkgs/issues/232679
    group = "users";
    overrideFolders = true;
    overrideDevices = true;
    guiAddress = "127.0.0.1:8384";
    extraOptions =  {
      gui = {
        theme = "black";
        insecureAdminAccess = true;
      };
      options = {
        localAnnounceEnabled = false;
      };
    };
    configDir = "/home/snd/.config/syncthing"; # required
    folders = {
      audiobooks = {
        enable = true;
        type = "receiveonly";
        path = "~/audio/audiobooks";
      };
    };
    devices = {
      nix-server = { id = "MZLIZ43-Y35VHGJ-PR6V63G-YKTED2E-3U47U5D-YXEPWYL-S32USZV-BTVM3AX"; autoAcceptFolders = true; };
    };
  };
}
