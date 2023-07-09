{ nixosConfig, config, pkgs, lib, ... }:
lib.mkIf nixosConfig.setup.gui.enable {

  services.mpd = {
    enable = true;
    musicDirectory = "/home/snd/audio";
    network.listenAddress = "${config.services.mpd.dataDir}/socket";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire"
      }
      audio_output {
        type "fifo"
        name "my_fifo"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };  

  home.sessionVariables.MPD_HOST = config.services.mpd.network.listenAddress;
}

