{ config, pkgs, lib, ... }:
let 
  scarlett = config.setup.scarlett.enable;
in
{  
  options = with lib; with lib.types; {
    setup.scarlett.enable = mkEnableOption "scarlett";
  };

  config = lib.mkIf config.setup.gui.enable {

    sound.enable = true;
    
    services.blueman.enable = config.hardware.bluetooth.enable;
    hardware.bluetooth.enable = config.setup.bluetooth.enable; 

    security.rtkit.enable = true;
    
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mpc-cli
      playerctl
      cli-visualizer
      mpv
      easyeffects
      unstable.helvum # patch panel
      pavucontrol
      pulseaudio # pacmd and pactl
      (lib.mkIf scarlett alsa-scarlett-gui)
      spotify
    ];
    
    boot.extraModprobeConfig = lib.mkIf scarlett ''
      # Focusrite Scarlett Solo Gen 3 Mixer Driver
      options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
    '';
  };
}
