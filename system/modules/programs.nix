{ config, lib, pkgs, ... }:
let 
  gui = config.setup.gui.enable;
in
{  

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  services.greetd = {
    enable = gui;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -c sway";
        user = "greeter";
      };
    };
  };
  
  services.xserver = {
    enable = config.setup.gui.enable;
    layout = config.setup.keyboard;
    xkbVariant = "";
    libinput.enable = true;
    displayManager.startx.enable = true;
    windowManager.bspwm.enable = true;
    displayManager.lightdm.enable = false;
  };

  programs = {
    java.enable = true;
    adb.enable = gui;
    sway.enable = gui;
    light.enable = gui;
  };

}
