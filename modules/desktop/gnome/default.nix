{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  mkTuple = lib.mkTuple;
  cfg = config.nixos-snowfall.desktop.gnome;
  gdmHome = config.users.users.gdm.home;

  defaultExtensions = with pkgs.gnomeExtensions; [
    #built-in extensions
    user-themes
    removable-drive-menu
    places-status-indicator
    # explicitly downloaded extensions
    appindicator
    no-overview
    pano
    hot-edge
    pop-shell
    alphabetcial-app-grid
    just-perfection
    freon
  ];

  default-attrs = mapAttrs (key: mkDefault);
  nested-default-attrs = mapAttrs (key: default-attrs);
in
{
  options.nixos-snowfall.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    wallpaper = {
      light = mkOpt (oneOf [ str package ]) pkgs.nixos-snowfall.wallpapers.panoramic-view-light-nix "The light wallpaper to use.";
      dark = mkOpt (oneOf [ str package ]) pkgs.nixos-snowfall.wallpapers.panoramic-view-dark-nix "The dark wallpaper to use.";
    };
    color-scheme = mkOpt (enum [ "light" "dark" ]) "dark" "The color scheme to use.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
    suspend =
      mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    monitors = mkOpt (nullOr path) null "The monitors.xml file to create.";
    extensions = mkOpt (listOf package) [ ] "Extra Gnome extensions to install.";
  };

  config = mkIf cfg.enable {
    nixos-snowfall.system.xkb.enable = true;
    nixos-snowfall.desktop.addons = {
      gtk = enabled;
      wallpapers = enabled;
      #      electron-support = enabled;
    };

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnome.dconf-editor
    ] ++ defaultExtensions ++ cfg.extensions;

    environment.gnome.excludePackages = with pkgs.gnome; [
      pkgs.gnome-connections #rdp/remmina like tool
      pkgs.gnome-photos #photo gallery like thingy
      pkgs.gnome-tour # welcome thingy that shows new things in a gnome release
      pkgs.gnome-text-editor
      pkgs.xterm # we dont need too many terminals
      epiphany # web-browser, use firefox instead
      geary # email client, use thundebird instead
      adwaita-icon-theme # default icons
      gnome-screenshot # screenshot utility, use flameshot instead
      totem # video player, use vlc instead
      simple-scan # document scanner utility
      file-roller
      gnome-font-viewer
      gnome-system-monitor
      gnome-maps
      gnome-music
      gnome-contacts
      gnome-themes-extra
      gnome-weather
      gnome-logs
      gnome-backgrounds
      gnome-calendar
      gnome-characters
      gnome-clocks
    ];

    systemd.tmpfiles.rules = [
      "d ${gdmHome}/.config 0711 gdm gdm"
    ] ++ (
      # "./monitors.xml" comes from ~/.config/monitors.xml when GNOME
      # display information is updated.
      lib.optional (cfg.monitors != null) "L+ ${gdmHome}/.config/monitors.xml - - - - ${cfg.monitors}"
    );

    systemd.services.nixos-snowfall-user-icon = {
      before = [ "display-manager.service" ];
      wantedBy = [ "display-manager.service" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
      };

      script = ''
        config_file=/var/lib/AccountsService/users/${config.nixos-snowfall.user.name}
        icon_file=/run/current-system/sw/share/nixos-snowfall-icons/user/${config.plusultra.user.name}/${config.plusultra.user.icon.fileName}

        if ! [ -d "$(dirname "$config_file")"]; then
          mkdir -p "$(dirname "$config_file")"
        fi

        if ! [ -f "$config_file" ]; then
          echo "[User]
          Session=gnome
          SystemAccount=false
          Icon=$icon_file" > "$config_file"
        else
          icon_config=$(sed -E -n -e "/Icon=.*/p" $config_file)

          if [[ "$icon_config" == "" ]]; then
            echo "Icon=$icon_file" >> $config_file
          else
            sed -E -i -e "s#^Icon=.*$#Icon=$icon_file#" $config_file
          fi
        fi
      '';
    };

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    # Disable inital setup and online accounts in gnome.
    services.gnome = {
      gnome-inital-setup.enable = false;
      gnome-online-accounts.enable = false;
    };

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = cfg.wayland;
        autoSuspend = cfg.suspend;
      };
      desktopManager = {
        gnome = {
          enable = true;
          extraGSettingsOverrides = ''
            [com.ubuntu.login-screen]
            background-repeat='no-repeat'
            background-size='cover'
            background-color='#777777'
          '';
          # TODO add this back
          #background-picture-uri='file:///etc/nixos/home/linux/gnome/wallpaper.jpg'
        };
      };

    };

    nixos-snowfall.home.extraOptions = {
      dconf.settings =
        let
          user = config.users.users.${config.nixos-snowfall.user.name};
          get-wallpaper = wallpaper:
            if lib.isDerivation wallpaper then
              builtins.toString wallpaper
            else
              wallpaper;
        in
        nested-default-attrs {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            disabled-extensions = "disabled";
            enabled-extensions = (builtins.map (extension: extension.extensionUuid) (cfg.extensions ++ defaultExtensions))
              ++ [
              #builtin extensions
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "places-menu@gnome-shell-extensions.gcampax.github.com"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "apps-menu@gnome-shell-extensions.gcampax.github.com"
              "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
              "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
            ];
            favorite-apps =
              [ "org.gnome.Nautilus.desktop" ]
              ++ optional config.nixos-snowfall.apps.firefox.enable "firefox.desktop"
              ++ optional config.nixos-snowfall.apps.kitty.enable "kitty.desktop"
              ++ optional config.nixos-snowfall.apps.remmina.enable "org.remmina.Remmina.desktop"
              ++ optional config.nixos-snowfall.apps.obsidian.enable "obsidian.desktop"
              ++ optional config.nixos-snowfall.apps.spotify.enable "spotify.desktop"
              ++ optional config.nixos-snowfall.apps.element.enable "element-desktop.desktop"
              ++ optional config.nixos-snowfall.apps.steam.enable "steam.desktop";
          };

          "org/gnome/desktop/background" = {
            picture-uri = get-wallpaper cfg.wallpaper.light;
            picture-uri-dark = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/screensaver" = {
            picture-uri = get-wallpaper cfg.wallpaper.light;
            picture-uri-dark = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/interface" = {
            color-scheme = if cfg.color-scheme == "light" then "prefer-light" else "prefer-dark";
            enable-hot-corners = false;
            toolkit-accessibility = false;
            clock-show-weekday = true;
            gtk-theme = "Fluent-round";
            show-battery-percentage = true;
            font-name = "Noto Sans 11";
            monospace-font-name = "JetBrainsMono Nerd Font 10";
            document-font-name = "Noto Sans 11";
            font-hinting = "slight";
            font-antialiasing = "grayscale";
          };
          "org/gnome/desktop/wm/preferences" = {
            titlebar-font = "Noto Sans 11";
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };
          "org/gnome/shell/extensions/user-theme" = {
            name = "Fluent-round";
          };
          "org/gnome/mutter" = {
            dynamic-workspaces = true;
            edge-tiling = true;
          };
          "org/gnome/shell/extensions/just-perfection" = {
            #panel-size = 48;
            #activities-button = false;
          };
          "org/gnome/shell/extensions/pop-shell" = {
            tile-by-default = true;
            show-title = true;
            smart-gaps = true;
            stacking-with-mouse = true;
            snap-to-grid = false;
            show-skip-taskbar = true;
          };
          "org/gnome/desktop/input-sources" = {
            sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ee" ]) ];
            xkb-options = [ "terminate:ctrl_alt_bksp" ];
            show-all-sources = true;
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            screensaver = [ "<Shift>Escape" ];
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "Launch terminal";
            binding = "<Super>t";
            command = "kitty";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            name = "Flameshot screenshot";
            binding = "<Super>Print";
            command = "flameshot gui";
          };

        };
    };

  };
}
