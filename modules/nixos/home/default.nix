{ options, config, lib, namespace, ... }:

with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.home;
in
{
  options.${namespace}.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };
  # Import NVF under the user.
  config = {
    # enable .local/bin
    environment.localBinInPath = true;

    ${namespace} = {
      home.extraOptions = {
        home.stateVersion = config.system.stateVersion;
        home.file = mkAliasDefinitions options.${namespace}.home.file;
        xdg.enable = true;
        xdg.configFile = mkAliasDefinitions options.${namespace}.home.configFile;

        xdg.mimeApps = {
          enable = true;
          associations.added = {
            "application/pdf" = [ "org.gnome.Evince.desktop" ];
            "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
            "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
            "image/png" = [ "org.gnome.Loupe.desktop" ];
            "image/gif" = [ "org.gnome.Loupe.desktop" ];
            "image/webp" = [ "org.gnome.Loupe.desktop" ];
            "image/tiff" = [ "org.gnome.Loupe.desktop" ];
            "image/x-tga" = [ "org.gnome.Loupe.desktop" ];
            "image/vnd-ms.dds" = [ "org.gnome.Loupe.desktop" ];
            "image/x-dds" = [ "org.gnome.Loupe.desktop" ];
            "image/bmp" = [ "org.gnome.Loupe.desktop" ];
            "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];
            "image/vnd.radiance" = [ "org.gnome.Loupe.desktop" ];
            "image/x-exr" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-qoi" = [ "org.gnome.Loupe.desktop" ];
            "image/qoi" = [ "org.gnome.Loupe.desktop" ];
            "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
            "image/svg+xml-compressed" = [ "org.gnome.Loupe.desktop" ];
            "image/avif" = [ "org.gnome.Loupe.desktop" ];
            "image/heic" = [ "org.gnome.Loupe.desktop" ];
            "image/jxl" = [ "org.gnome.Loupe.desktop" ];
          };
          defaultApplications = {
            "text/plain" = [ "nvim.desktop" ];
            "application/pdf" = [ "org.gnome.Evince.desktop" ];
            "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
            "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
            "x-scheme-handler/nxm" = [ "com.nexusmods.app.desktop" ];
            "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
            "image/png" = [ "org.gnome.Loupe.desktop" ];
            "image/gif" = [ "org.gnome.Loupe.desktop" ];
            "image/webp" = [ "org.gnome.Loupe.desktop" ];
            "image/tiff" = [ "org.gnome.Loupe.desktop" ];
            "image/x-tga" = [ "org.gnome.Loupe.desktop" ];
            "image/vnd-ms.dds" = [ "org.gnome.Loupe.desktop" ];
            "image/x-dds" = [ "org.gnome.Loupe.desktop" ];
            "image/bmp" = [ "org.gnome.Loupe.desktop" ];
            "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];
            "image/vnd.radiance" = [ "org.gnome.Loupe.desktop" ];
            "image/x-exr" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
            "image/x-qoi" = [ "org.gnome.Loupe.desktop" ];
            "image/qoi" = [ "org.gnome.Loupe.desktop" ];
            "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
            "image/svg+xml-compressed" = [ "org.gnome.Loupe.desktop" ];
            "image/avif" = [ "org.gnome.Loupe.desktop" ];
            "image/heic" = [ "org.gnome.Loupe.desktop" ];
            "image/jxl" = [ "org.gnome.Loupe.desktop" ];
          };

        };
      };
    };

    #snowfallorg.users.${config.${namespace}.user.name}.home.config = config.${namespace}.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.nixos-snowfall.user.name} =
        mkAliasDefinitions options.nixos-snowfall.home.extraOptions;
    };
  };
}
