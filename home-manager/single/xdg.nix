{ lib, config, ...}:
{
  xdg.mime = {
    enable = true;
  };
  
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "image/png" = ["org.gnome.gThumb.desktop"];
      "image/jpeg" = ["org.gnome.gThumb.desktop"];
      "image/tiff" = ["org.gnome.gThumb.desktop"];
      "image/svg+xml" = ["org.gnome.gThumb.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "audio/mpeg" = ["mpv.desktop"];
      "application/json" = ["nvim.desktop"];
      "application/yaml" = ["nvim.desktop"];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/magnet" = ["deluge.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "text/html" = ["nvim.desktop"];
    };
    defaultApplications = {
      "image/png" = ["org.gnome.gThumb.desktop"];
      "image/jpeg" = ["org.gnome.gThumb.desktop"];
      "image/tiff" = ["org.gnome.gThumb.desktop"];
      "image/svg+xml" = ["org.gnome.gThumb.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "audio/mpeg" = ["mpv.desktop"];
      "application/json" = ["nvim.desktop"];
      "application/yaml" = ["nvim.desktop"];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/magnet" = ["deluge.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "text/html" = ["nvim.desktop"];
    };
  };

  home.file."user-dirs.dirs".target = ".config/user-dirs.dirs";
  home.file."user-dirs.dirs".text = ''
# This file is written by xdg-user-dirs-update
# If you want to change or add directories, just edit the line you're
# interested in. All local changes will be retained on the next run.
# Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
# absolute path. No other format is supported.
# 
XDG_SCREENSHOTS_DIR="$HOME/pictures/screenshots"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_MUSIC_DIR="$HOME/audio"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_NEXTCLOUD_DIR="$HOME/nextcloud"
XDG_DESKTOP_DIR="$HOME/.default"
XDG_TEMPLATES_DIR="$HOME/.default"
XDG_PUBLICSHARE_DIR="$HOME/.default"
XDG_DOCUMENTS_DIR="$HOME/.default"
XDG_VIDEOS_DIR="$HOME/.default"
  '';

  home.file."user-dirs.locale".target = ".config/user-dirs.locale";
  home.file."user-dirs.locale".text = ''
en_US
  '';
}
