{ nixosConfig, config, pkgs, lib, ... }:
let 
  polybar = if nixosConfig.setup.screen == "big" then ''
    polybar right & polybar left
  '' else ''
    polybar
  '';
  xrandr = if nixosConfig.setup.screen == "big" then ''
xrandr --auto --output HDMI-A-0 --left-of DisplayPort-0
  '' else ''
  '';
  monitor = if nixosConfig.setup.screen == "big" then ''
bspc monitor DisplayPort-0 -d 5 6 7 8 
bspc monitor HDMI-A-0 -d 1 2 3 4
  '' else ''
bspc monitor -d I II III IV V VI VII VIII 
  '';
  alacritty-font-size = if nixosConfig.setup.screen == "big" then "8" else "6";
in  
{
  xsession.windowManager.bspwm = {
    enable = nixosConfig.setup.gui.enable;
    extraConfig = ''
      #! /bin/sh
      # das script muss ausfuhrbar sein
      pgrep -x sxhkd > /dev/null || sxhkd &

      xrandr --dpi 96

      #setxkbmap ändert das keyboard layout zu de (QWERTZ)
      setxkbmap ${nixosConfig.setup.keyboard}

      ${xrandr}

      ${monitor}

      bspc config border_width        2
      bspc config window_gap          0
      bspc config split_ratio         0.50

      bspc config normal_border_color "#282c34" #nicht fokusiertes program fenster
      bspc config focused_border_color "#c678dd" #fokusiertes program fenster

      ${polybar}
    '';
  };

  services.sxhkd = {
    enable = config.xsession.windowManager.bspwm.enable;
    keybindings = {
      "XF86MonBrightnessUp" = "light -A 5";
      "XF86MonBrightnessDown" = "light -U 5";
      "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "super + i" = "alacritty -o font.size=${alacritty-font-size}";
      "super + p" = ''rofi -show run -font "Hack Nerd Font 10"'';
      "super + Escape" = "pkill -USR1 -x sxhkd";
      "super + {_,shift +}q" = "bspc node -{c,k}";
      "super + alt + {q,r}" = "bspc {quit,wm -r}";
      "super + {_,shift + }{1-8}" = "bspc {desktop -f,node -d} '^{1-8}'";
    };
  };
}
