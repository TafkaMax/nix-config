{ nixosConfig, config, pkgs, lib, ... }:
let 
    font-size = if nixosConfig.setup.screen == "big" then "16" else "10";
    width = if nixosConfig.setup.screen == "big" then 3840 else 1920;
    height = if nixosConfig.setup.screen == "big" then 30 else 0;
    padding = if nixosConfig.setup.screen == "big" then "10" else "8";
    theme = nixosConfig.theme;
in
{
  programs.waybar =  {
    enable = nixosConfig.setup.gui.enable;
    settings = {
      mainBar = {
        layer = "bottom";
        positon = "top";
        height = height;
        width = width;
        spacing = 0;
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "mpd" "network" "idle_inhibitor" "pulseaudio" "memory" "cpu" "temperature" "backlight" "keyboard-state" "battery" "clock" ];

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = { 
            locked = " "; 
            unlocked = " "; 
          };
        };
        
        "sway/mode" = { 
          format = "<span style=\"italic\">{}</span>"; 
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [ "" " " ];
          tooltip = true;
          tooltip-format ="{app}: {title}";
        };

        "mpd" = {
          server = config.services.mpd.network.listenAddress;
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}%  ";
          format-disconnected = "Disconnected  ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped  ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"> </span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1";
          };
          state-icons = {
            paused = " ";
            playing = " ";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          # FIXME remove this once waybar fixes the regression (https://github.com/Alexays/Waybar/issues/1778)
          on-click = "${pkgs.mpc_cli}/bin/mpc -q -h ${config.services.mpd.network.listenAddress} toggle";
          on-click-right = "${pkgs.mpc_cli}/bin/mpc -q -h ${config.services.mpd.network.listenAddress} stop";
          on-scroll-up = "${pkgs.mpc_cli}/bin/mpc -q -h ${config.services.mpd.network.listenAddress} volume +2";
          on-scroll-down = "${pkgs.mpc_cli}/bin/mpc -q -h ${config.services.mpd.network.listenAddress} volume -2";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        "tray" = {
          icon-size = 21;
          spacing = 0;
        };
        
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "cpu" = {
          format = "{usage}%  ";
          tooltip = false;
        };

        "memory" = {
          format = "{}%  ";
        };

        "temperature" = {
          critical-threshold = 80;
          format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [" " " " " "];
        };

        "backlight" = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄 ";
          format-plugged = "{capacity}%  ";
          format-alt = "{time} {icon}";
          format-icons = [" " " " " " " " " "];
        };

        "battery#bat2" = {
          bat = "BAT2";
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ipaddr}/{cidr}  ";
          tooltip-format = "{ifname} via {gwaddr}  ";
          format-linked = "{ifname} (No IP)  ";
          format-disconnected = "Disconnected ⚠ ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "󰝛 {icon} {format_source}";
          format-muted = "󰝛 {format_source}";
          format-source = "{volume}%  ";
          format-source-muted = " ";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = "";
            car = " ";
            default = [" " " " " "];
          };
          on-click = "pavucontrol";
        };
      };
    };

    style = ''
      * {
        border: none;
        padding: 0;
        font-family: ${theme.font};
        font-size: ${font-size};
      }

      window#waybar {
        background-color: transparent;
      }

      window>box {
        margin: 0 0 0 0;
        background: ${theme.colours.bg};
        opacity: 1;
        border-radius: 0;
      }

      .modules-right {
        margin-right: 10;
        padding: 5 10;
      }

      .modules-center {
        margin: 0;
        padding: 5 10;
      }

      .modules-left {
        margin-left: 10;
        padding: 5 0;
      }

      #workspaces button {
        padding: 0 10;
        background-color: transparent;
        font-weight: lighter;
        color: ${theme.colours.text};
      }

      #workspaces button:hover {
        color: ${theme.colours.red};
        background-color: transparent;
      }

      #workspaces button.focused, #workspaces button.active {
        color: ${theme.colours.red};
        font-weight: normal;
        background-color: transparent;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #custom-power,
      #custom-menu,
      #idle_inhibitor {
        padding: 0 10;
        color: ${theme.colours.text};
      }

      #mode {
        font-weight: bold;
      }

      #custom-power {
        color: ${theme.colours.accent};
        background-color: transparent;
      }

      /*-----Indicators----*/
      #idle_inhibitor.activated {
        color: ${theme.colours.accent};
      }

      #battery.charging {
        color: ${theme.colours.green};
      }

      #battery.warning:not(.charging) {
        color: ${theme.colours.orange};
      }

      #battery.critical:not(.charging) {
        color: ${theme.colours.red};
      }

      #temperature.critical {
        color: ${theme.colours.red};
      }
    '';

  };

}
